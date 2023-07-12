//
//  UserService.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-22.
//

import SwiftUI
import KeychainSwift


struct UserCredentials: Codable {
    let email: String
    let password: String
}

class UserService {
    let baseUrl = "http://localhost:3500/user"
    let keychain = KeychainSwift()

    func login(credentials: UserCredentials, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        // Construct the URL and request.
        guard let url = URL(string: "\(baseUrl)/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the login credentials.
        request.httpBody = try? JSONEncoder().encode(credentials)

        // Make the network request.
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response.
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                // Decode the response.
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.storeTokensInKeychain(access: loginResponse.accessToken, refresh: loginResponse.refreshToken)
                        completion(.success(loginResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
            }
        }.resume()
    }
    
    private func storeTokensInKeychain(access: String, refresh: String) {
        keychain.set(access, forKey: "accessToken")
        keychain.set(refresh, forKey: "refreshToken")
    }

    // Add other methods like register, logout, etc here.
}
