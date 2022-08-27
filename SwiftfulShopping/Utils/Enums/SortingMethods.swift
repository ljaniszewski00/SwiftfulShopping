//
//  SortingMethods.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 15/08/2022.
//

import Foundation

enum SortingMethods: String, CaseIterable {
    case priceAscending = "Price Ascending"
    case priceDescending = "Price Descending"
    case popularity = "Popularity"
    case ratingAscending = "Rating Ascending"
    case ratingDescending = "Rating Descending"
    case reviewsAscending = "Reviews Ascending"
    case reviewsDescending = "Reviews Descending"
    
    static var allCases: [SortingMethods] {
        return [.priceAscending, .priceDescending, .popularity, .ratingAscending, .ratingDescending, .reviewsAscending, .reviewsDescending]
    }
}
