//
//  TabsWithProducts.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 16/08/2022.
//

import Foundation

enum TabsWithProducts: String, CaseIterable {
    case exploreView
    case searchView
    
    static var allCases: [TabsWithProducts] {
        [.exploreView, .searchView]
    }
}
