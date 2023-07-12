//
//  ThreadModel.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-17.
//

import SwiftUI

struct Thread: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let content: [ThreadContent]
    let link: String
    let createdBy: String
    let createdAt: String
    let updatedAt: String
    let likes: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case content
        case link
        case createdBy
        case createdAt
        case updatedAt
        case likes
    }
}

struct ThreadContent: Codable, Hashable  {
    let type: String
    let content: String
}

struct ThreadCredentials: Codable {
    let title: String
    let description: String
    let content: [ThreadContent]
    let link: String
}
