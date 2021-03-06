//
//  Category.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import Foundation

enum Category: String, CaseIterable {
    case phones = "Phones"
    case tablets = "Tablets"
    case laptops = "Laptops"
    case watches = "Watches"
    case accessories = "Accessories"
    case other = "Other"
    
    static var allCases: [Category] {
        [.phones, .tablets, .laptops, .watches, .accessories, .other]
    }
}
