//
//  TabBarItem.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/11/2022.
//

import SwiftUI
import texterify_ios_sdk

enum TabBarItem: Hashable {
    case explore
    case favorites
    case cart
    case search
    case profile
    
    var iconName: String {
        switch self {
        case .explore:
            return "house"
        case .favorites:
            return "star"
        case .cart:
            return "cart"
        case .search:
            return "magnifyingglass"
        case .profile:
            return "person"
        }
    }
    
    var title: String {
        switch self {
        case .explore:
            return TexterifyManager.localisedString(key: .homeView(.exploreTabName))
        case .favorites:
            return TexterifyManager.localisedString(key: .homeView(.favoritesTabName))
        case .cart:
            return TexterifyManager.localisedString(key: .homeView(.cartTabName))
        case .search:
            return TexterifyManager.localisedString(key: .homeView(.searchTabName))
        case .profile:
            return TexterifyManager.localisedString(key: .homeView(.profileTabName))
        }
    }
}
