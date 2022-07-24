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
    
    func addProductToCart(productID: String, quantity: Int) {
        var added: Bool = false
        for product in Array(products.keys) where product.id == productID {
            products[product]! += quantity
            added = true
            break
        }
        if !added {
            if let product = ProductsRepository.shared.getProductFor(productID: productID) {
                products[product] = quantity
            }
        }
    }
    
    func removeProductFromCart(productID: String, quantity: Int) {
        for product in Array(products.keys) where product.id == productID {
            if products[product]! >= 0 {
                if products[product]! - quantity < 0 {
                    products[product] = nil
                } else {
                    products[product]! -= quantity
                }
            }
        }
    }
    
    func removeAllProductsFromCart() {
        products.removeAll()
    }
    
    func getCartProductCount(productID: String) -> Int {
        for product in Array(products.keys) where product.id == productID {
            return products[product]!
        }
        return 0
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
