//
//  Category.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import Foundation
import texterify_ios_sdk

enum Category: String, CaseIterable {
    case computers
    case phones
    case tablets
    case laptops
    case watches
    case accessories
    case other
    
    var rawValue: String {
        switch self {
        case .computers:
            return TexterifyManager.localisedString(key: .category(.computers))
        case .phones:
            return TexterifyManager.localisedString(key: .category(.phones))
        case .tablets:
            return TexterifyManager.localisedString(key: .category(.tablets))
        case .laptops:
            return TexterifyManager.localisedString(key: .category(.laptops))
        case .watches:
            return TexterifyManager.localisedString(key: .category(.watches))
        case .accessories:
            return TexterifyManager.localisedString(key: .category(.accessories))
        case .other:
            return TexterifyManager.localisedString(key: .category(.other))
        }
    }
    
    var decodeValue: String {
        switch self {
        case .computers:
            return "Computers"
        case .phones:
            return "Phones"
        case .tablets:
            return "Tablets"
        case .laptops:
            return "Laptops"
        case .watches:
            return "Watches"
        case .accessories:
            return "Accessories"
        case .other:
            return "Other"
        }
    }
}

extension Category {
    static var allCases: [Category] {
        [.computers, .phones, .tablets, .laptops, .watches, .accessories, .other]
    }
}

extension Category {
    static func withLabel(_ label: String) -> Category? {
        return self.allCases.first { "\($0.decodeValue)" == label }
    }
}
