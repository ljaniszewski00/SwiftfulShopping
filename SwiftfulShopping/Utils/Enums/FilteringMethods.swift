//
//  FilteringMethods.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 15/08/2022.
//

import Foundation

enum FilteringMethods: String, CaseIterable {
    case company = "Company"
    case category = "Category"
    case price = "Price"
    case rating = "Rating"
    
    static var allCases: [FilteringMethods] {
        return [.company, .category, .price, .rating]
    }
}
