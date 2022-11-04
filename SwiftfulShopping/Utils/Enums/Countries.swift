//
//  Countries.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation
import texterify_ios_sdk

enum Countries: String, CaseIterable {
    case czech
    case england
    case france
    case germany
    case poland
    case spain
    case unitedStates
    
    static var allCases: [Countries] = [.czech,
                                        .england,
                                        .france,
                                        .germany,
                                        .poland,
                                        .spain,
                                        .unitedStates]
    
    var rawValue: String {
        switch self {
        case .czech:
            return TexterifyManager.localisedString(key: .countries(.czech))
        case .england:
            return TexterifyManager.localisedString(key: .countries(.england))
        case .france:
            return TexterifyManager.localisedString(key: .countries(.france))
        case .germany:
            return TexterifyManager.localisedString(key: .countries(.germany))
        case .poland:
            return TexterifyManager.localisedString(key: .countries(.poland))
        case .spain:
            return TexterifyManager.localisedString(key: .countries(.spain))
        case .unitedStates:
            return TexterifyManager.localisedString(key: .countries(.unitedStates))
        }
    }
}

extension Countries {
    static func withLabel(_ label: String) -> Countries? {
        return self.allCases.first { "\($0.rawValue)" == label }
    }
}
