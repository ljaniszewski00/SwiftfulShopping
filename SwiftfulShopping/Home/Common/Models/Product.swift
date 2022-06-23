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
    var description: String
    var price: Double
    var imageURL: String? = nil
}

extension Product {
    static let demoProducts: [Product] = [Product(id: UUID().uuidString,
                                                  name: "Product 1",
                                                  description: "This is the standard description of product 1",
                                                  price: 20.15),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  description: "This is the standard description of product 2",
                                                  price: 10.15)]
}
