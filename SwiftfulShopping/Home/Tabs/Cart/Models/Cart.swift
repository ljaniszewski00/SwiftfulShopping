//
//  Cart.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

class Cart {
    var id: String = UUID().uuidString
    var cartName: String = "Default"
    var products: [Product: Int] = [:]
    
    static var shared: Cart = {
        return Cart()
    }()
    
    private init() {}
    
    func addProductToCart(product: Product, quantity: Int) {
        if products[product] != nil {
            products[product]! += quantity
        } else {
            products[product] = quantity
        }
    }
    
    func removeProductFromCart(product: Product, quantity: Int) {
        if products[product] != nil {
            if products[product]! >= 0 {
                if products[product]! - quantity < 0 {
                    products[product]! = 0
                } else {
                    products[product]! -= quantity
                }
            }
        }
    }
    
    func getCartProductsCount() -> Int {
        return products.keys.count
    }
    
    func getCartTotalCost() -> Double {
        var totalCost: Double = 0
        for (product, quantity) in products {
            totalCost += product.price * Double(quantity)
        }
        return totalCost
    }
}

extension Cart {
    static let demoCart = Cart()
}
