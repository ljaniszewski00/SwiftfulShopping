//
//  ProductsListSource.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/09/2022.
//

import Foundation
import texterify_ios_sdk

enum ProductsListSource: String {
    case category
    case newest
    case company
    case recommended
    case all
    
    var rawValue: String {
        switch self {
        case .category:
            return TexterifyManager.localisedString(key: .productsListSource(.category))
        case .newest:
            return TexterifyManager.localisedString(key: .productsListSource(.newest))
        case .company:
            return TexterifyManager.localisedString(key: .productsListSource(.company))
        case .recommended:
            return TexterifyManager.localisedString(key: .productsListSource(.recommended))
        case .all:
            return TexterifyManager.localisedString(key: .productsListSource(.all))
        }
    }
}
