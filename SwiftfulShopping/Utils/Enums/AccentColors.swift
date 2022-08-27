//
//  AccentColors.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 14/08/2022.
//

import UIKit

enum AccentColors: CaseIterable {
    case swiftfulShoppingDefaultGreen
    case blue
    case red
    case green
    case purple
    case yellow
    
    static var allCases: [AccentColors] {
        return [.swiftfulShoppingDefaultGreen, .blue, .red, .green, .purple, .yellow]
    }
}

extension AccentColors: RawRepresentable {
    typealias RawValue = UIColor
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case #colorLiteral(red: 0.306, green: 0.675, blue: 0.569, alpha: 1): self = .swiftfulShoppingDefaultGreen
        case #colorLiteral(red: 0, green: 77, blue: 249, alpha: 1): self = .blue
        case #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1): self = .red
        case #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1): self = .green
        case #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1): self = .purple
        case #colorLiteral(red: 252, green: 196, blue: 99, alpha: 1): self = .yellow
        default: return nil
        }
    }
    
    var rawValue: UIColor {
        switch self {
        case .swiftfulShoppingDefaultGreen: return #colorLiteral(red: 0.306, green: 0.675, blue: 0.569, alpha: 1)
        case .blue: return #colorLiteral(red: 0.1209159801, green: 0.2143797468, blue: 1, alpha: 1)
        case .red: return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .green: return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .purple: return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case .yellow: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
    }
}
