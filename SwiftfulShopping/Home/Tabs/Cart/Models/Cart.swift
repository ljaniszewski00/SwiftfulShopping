//
//  Cart.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Cart {
    var id: String
    var cartName: String = "Default"
    var products: [Product]
    var totalCost: Double
}

extension Cart {
    static let demoCart = Cart(id: UUID().uuidString,
                               cartName: "Cart 1",
                               products: Product.demoProducts,
                               totalCost: 30.30)
}
