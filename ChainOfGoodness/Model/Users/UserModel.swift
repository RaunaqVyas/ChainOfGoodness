//
//  UserModel.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-15.
//

import SwiftUI

struct User: Codable {
    let id: String
    let email: String
    let password: String
    let createdAt: Int64
    let updatedAt: Int64
}

