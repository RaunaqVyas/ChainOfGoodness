//
//  ThreadService.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-17.
//

import SwiftUI
import KeychainSwift

class ThreadService {
    let baseUrl = "http://localhost:3213/threads"
    let keychain = KeychainSwift()
    

    func deleteThread(threadId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/deleteThread/\(threadId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let accessToken = keychain.get("accessToken") ?? ""
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
            }
        }.resume()
    }

    func getUserThreads(userId: String, completion: @escaping (Result<[Thread], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/userThreads/\(userId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let accessToken = keychain.get("accessToken") ?? ""
        print(" token is \(accessToken)")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    let threads = try JSONDecoder().decode([Thread].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(threads))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
            }
        }.resume()
    }

    func editThread(threadId: String, updatedThread: ThreadCredentials, completion: @escaping (Result<Thread, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/editThread/\(threadId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let accessToken = keychain.get("accessToken") ?? ""
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try? JSONEncoder().encode(updatedThread)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    let thread = try JSONDecoder().decode(Thread.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(thread))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
            }
        }.resume()
    }

    // Add other methods here.
}

