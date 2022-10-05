//
//  Countries.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

enum Countries: String, CaseIterable {
    case czech = "Czech"
    case england = "England"
    case france = "France"
    case germany = "Germany"
    case poland = "Poland"
    case spain = "Spain"
    case unitedStates = "United States"
    
    static var allCases: [Countries] = [.czech,
                                        .england,
                                        .france,
                                        .germany,
                                        .poland,
                                        .spain,
                                        .unitedStates]
}

extension Countries {
    static func withLabel(_ label: String) -> Countries? {
        return self.allCases.first { "\($0)" == label }
    }
}
