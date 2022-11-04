//
//  ExploreViewTabs.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/07/2022.
//

import Foundation
import texterify_ios_sdk

enum ExploreViewTabs: String, CaseIterable {
    case trending
    case categories
    case weRecommend
    
    static var allCases: [ExploreViewTabs] {
        [.trending, .categories, .weRecommend]
    }
    
    var rawValue: String {
        switch self {
        case .trending:
            return TexterifyManager.localisedString(key: .exploreViewTabs(.trending))
        case .categories:
            return TexterifyManager.localisedString(key: .exploreViewTabs(.categories))
        case .weRecommend:
            return TexterifyManager.localisedString(key: .exploreViewTabs(.weRecommend))
        }
    }
}
