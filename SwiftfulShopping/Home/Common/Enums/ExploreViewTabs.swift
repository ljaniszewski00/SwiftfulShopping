//
//  ExploreViewTabs.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/07/2022.
//

import Foundation

enum ExploreViewTabs: String, CaseIterable {
    case trending = "Trending"
    case categories = "Categories"
    case weRecommend = "We recommend"
    
    static var allCases: [ExploreViewTabs] {
        [.trending, .categories, .weRecommend]
    }
}
