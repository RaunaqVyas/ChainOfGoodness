//
//  Suggestion.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-06.
//

import SwiftUI

struct Suggestion: Identifiable {
    let id = UUID()
    var text: String
}

var suggestions = [
    Suggestion(text: "SwiftUI"),
    Suggestion(text: "SwiftUI"),
    Suggestion(text: "SwiftUI")

]
