//
//  FilteringMethods.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 15/08/2022.
//

import Foundation
import texterify_ios_sdk

enum FilteringMethods: String, CaseIterable {
    case company
    case category
    case price
    case rating
    
    static var allCases: [FilteringMethods] {
        return [.company, .category, .price, .rating]
    }
    
    var rawValue: String {
        switch self {
        case .company:
            return TexterifyManager.localisedString(key: .filteringMethods(.company))
        case .category:
            return TexterifyManager.localisedString(key: .filteringMethods(.category))
        case .price:
            return TexterifyManager.localisedString(key: .filteringMethods(.price))
        case .rating:
            return TexterifyManager.localisedString(key: .filteringMethods(.rating))
        }
    }
}
