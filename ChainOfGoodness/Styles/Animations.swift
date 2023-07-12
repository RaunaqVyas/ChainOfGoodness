//
//  Animations.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-09.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.9)
}

