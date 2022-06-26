//
//  Product.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Product {
    var id: String
    var name: String
    var company: String
    var productDescription: String
    var price: Double
    var imageURL: String? = nil
}

extension Product: Equatable, Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Product: CustomStringConvertible {
    var description: String {
        "\(id)\n\(name)\n\(company)\n\(productDescription)\n\(price)"
    }
}

extension Product {
    static let demoProducts: [Product] = [Product(id: UUID().uuidString,
                                                  name: "Product 1",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 1",
                                                  price: 20.15),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  price: 10.15)]
}
