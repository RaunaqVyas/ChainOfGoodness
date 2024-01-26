//
//  Chain_Of_GoodnessApp.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-22.
//

import SwiftUI
import Amplify
import Combine
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin



@main
struct DesignCodeiOS15App: App {
    @StateObject var model = Model()
    @ObservedObject var sessionManager = SessionManager()
    
    init() {
        configureAmplify()
        let sessionManager = self.sessionManager
        Task {
            do {
                await sessionManager.getCurrentAuthUser()
                await sessionManager.fetchTokens()
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                ModalView()
                    .environmentObject(sessionManager)
                    .environmentObject(model)
            case .signUp:
                ModalView()
                    .environmentObject(sessionManager)
                    .environmentObject(model)
                
            case .confirmCode(username: let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
            case .session(user: let user):
                ContentView(user: user ?? DummyUser())
                    .environmentObject(sessionManager)
                    .environmentObject(model)
                
            }
            
        }
    }
    func configureAmplify(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            try Amplify.configure()
            print("Amplify configured with Auth and Storage plugins")
            
        } catch{
            print("Amplify was unable to be configured")
        }
        
    }
}

struct DummyUser: AuthUser {
    let userId: String = "1"
    let username: String = "dummy"
}
