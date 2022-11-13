//
//  Availability.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 13/11/2022.
//

import Foundation
import texterify_ios_sdk

enum Availability: String {
    case large
    case small
    case no
    
    var rawValue: String {
        switch self {
        case .large:
            return TexterifyManager.localisedString(key: .availability(.large))
        case .small:
            return TexterifyManager.localisedString(key: .availability(.small))
        case .no:
            return TexterifyManager.localisedString(key: .availability(.no))
        }
    }
    
    var decodeValue: String {
        switch self {
        case .large:
            return "Large"
        case .small:
            return "Small"
        case .no:
            return "No"
        }
    }
}

extension Availability {
    static var allCases: [Availability] {
        [.large, .small, .no]
    }
}

extension Availability {
    static func withLabel(_ label: String) -> Availability? {
        return self.allCases.first { "\($0.decodeValue)" == label }
    }
}
