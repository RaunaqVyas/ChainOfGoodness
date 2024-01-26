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
    let Colour: String
    let displayName: String
    let image: String?

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
        case Colour
        case displayName
        case image
    }
}

struct ThreadContent: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    var content: String
    var type: String
    var height: CGFloat = 0
    var showImage: Bool = false
    var showDeleteAlert: Bool = false

    // Exclude the id from the decoding process
    enum CodingKeys: String, CodingKey {
        case content, type
        // The id, height, showImage, and showDeleteAlert are excluded from the decoding process
    }
}

struct ThreadCredentials: Codable {
    let title: String
    let description: String
    let content: [ThreadContent]
    let link: String
    let image: String?
}

