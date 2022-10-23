//
//  Category.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import Foundation

enum Category: String, CaseIterable {
    case computers = "Computers"
    case phones = "Phones"
    case tablets = "Tablets"
    case laptops = "Laptops"
    case watches = "Watches"
    case accessories = "Accessories"
    case other = "Other"
}

extension Category {
    static var allCases: [Category] {
        [.computers, .phones, .tablets, .laptops, .watches, .accessories, .other]
    }
}

extension Category {
    static func withLabel(_ label: String) -> Category? {
        return self.allCases.first { "\($0.rawValue)" == label }
    }
}
