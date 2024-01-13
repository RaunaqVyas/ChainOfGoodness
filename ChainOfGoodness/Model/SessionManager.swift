//
//  SessionManager.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2023-05-24.
//


import Amplify
import Combine
import AWSCognitoAuthPlugin
import SwiftUI
import AWSCognitoIdentityProvider
import AWSPluginsCore
import KeychainSwift

enum AuthState {
    case signUp
    case login
    case confirmCode (username: String)
    case session(user: AuthUser?)
}

enum Modal: String {
    case signUp
    case signIn
    case confirmation
}


final class SessionManager: ObservableObject {
    @Published var selectedModal: Modal = .signIn
    @Published var authState: AuthState = .login {
        didSet {
            print("authState changed to: \(authState)")
        }
    }
    @Published var accessToken: String = ""
    @Published var refreshToken: String = ""
    @Published var currentUser: AuthUser? = nil
    let keychain = KeychainSwift()
    private let threadService = ThreadService()

    
    func getCurrentAuthUser() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            DispatchQueue.main.async {
                self.authState = .session(user: user)
                self.currentUser = user
            }
        } catch {
            print("User not authorized")
        }
    }


    
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin(){
        authState = .login
    }
    

    func signUp(username: String, password: String, email: String, pictureUrl: String) async {
        let userAttributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.preferredUsername, value: username),
            AuthUserAttribute(.picture, value: pictureUrl)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )
            // rest of your code...
            DispatchQueue.main.async {
                    self.authState = .confirmCode(username: username)
                }
            
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }


    
    func confirmSignUp(for username: String, with confirmationCode: String) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
            DispatchQueue.main.async {
                if confirmSignUpResult.isSignUpComplete {
                    print("Confirmation successful. Transitioning to login...")
                    self.authState = .login
                } else {
                    print("Confirmation not complete.")
                }
            }
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    
    
    func signIn(username: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: username,
                password: password
                )
            if signInResult.isSignedIn {
                await self.getCurrentAuthUser()
                await self.fetchTokens()
                let user = try await Amplify.Auth.getCurrentUser()
                let attributes = try await Amplify.Auth.fetchUserAttributes()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signOutLocally() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
        case .complete:
            // Sign Out completed fully and without errors.
            print("Signed out successfully")
            keychain.delete("accessToken")
            keychain.delete("refreshToken")
            self.authState = .login

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.
            
            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
    
    func fetchTokens() async {
            do {
                if let cognitoTokenProvider = try await Amplify.Auth.fetchAuthSession() as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    print(" Token is : \(tokens.accessToken)")
                    self.accessToken = tokens.idToken
                    self.refreshToken = tokens.refreshToken

                    // Save tokens in Keychain
                    keychain.set(tokens.accessToken, forKey: "accessToken")
                    keychain.set(tokens.refreshToken, forKey: "refreshToken")
                }
            } catch {
                print("Failed to fetch tokens - \(error)")
            }
        }
    
    func fetchUserAttributes() async {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            if let emailAttribute = attributes.first(where: { $0.key == .email }) {
                print("User's email is \(emailAttribute.value)")
            }
        } catch {
            print("Failed to fetch user attributes - \(error)")
        }
    }
    //


}
