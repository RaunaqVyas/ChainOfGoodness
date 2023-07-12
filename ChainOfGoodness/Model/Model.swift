//
//  Model.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-04.
//

import SwiftUI
import Combine
import KeychainSwift

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

class Model: ObservableObject {
    @Published var showDetail: Bool = false
    @Published var isAuthenticated = false
    @Published var threads = [Thread]()
    @Published var accessToken: String = ""
    @Published var refreshToken: String = ""
    @ObservedObject var sessionManager = SessionManager()
    
    private let userService = UserService()
   
    
    
        
    }
    



