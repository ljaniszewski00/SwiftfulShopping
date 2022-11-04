//
//  SortingMethods.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 15/08/2022.
//

import Foundation
import texterify_ios_sdk

enum SortingMethods: String, CaseIterable {
    case priceAscending
    case priceDescending
    case popularity
    case ratingAscending
    case ratingDescending
    case reviewsAscending
    case reviewsDescending
    
    static var allCases: [SortingMethods] {
        return [.priceAscending, .priceDescending, .popularity, .ratingAscending, .ratingDescending, .reviewsAscending, .reviewsDescending]
    }
    
    var rawValue: String {
        switch self {
        case .priceAscending:
            return TexterifyManager.localisedString(key: .sortingMethods(.priceAscending))
        case .priceDescending:
            return TexterifyManager.localisedString(key: .sortingMethods(.priceDescending))
        case .popularity:
            return TexterifyManager.localisedString(key: .sortingMethods(.popularity))
        case .ratingAscending:
            return TexterifyManager.localisedString(key: .sortingMethods(.ratingAscending))
        case .ratingDescending:
            return TexterifyManager.localisedString(key: .sortingMethods(.ratingDescending))
        case .reviewsAscending:
            return TexterifyManager.localisedString(key: .sortingMethods(.reviewsAscending))
        case .reviewsDescending:
            return TexterifyManager.localisedString(key: .sortingMethods(.reviewsDescending))
        }
    }
}
