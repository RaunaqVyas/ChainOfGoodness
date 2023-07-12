//
//  Crop.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-08.
//

import SwiftUI

// MARK: Crop Config
enum Crop: Equatable{
    case edit
    case rectangle
    case square
    case custom(CGSize)
    
    func name()->String{
        switch self {
        case .edit:
            return "Edit"
        case .rectangle:
            return "Rectangle"
        case .square:
            return "Square"
        case let .custom(cGSize):
            return "Custom \(Int(cGSize.width))X\(Int(cGSize.height))"
        }
    }
    
    func size()->CGSize{
        switch self {
        case .edit:
            return .init(width: 300, height: 300)
        case .rectangle:
            return .init(width: 300, height: 500)
        case .square:
            return .init(width: 300, height: 300)
        case .custom(let cGSize):
            return cGSize
        }
    }
}
