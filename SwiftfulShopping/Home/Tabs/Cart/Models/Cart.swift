//
//  Cart.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Cart {
    var id: String = UUID().uuidString
    var cartName: String = "Default"
    var products: [Product: Int] = [:]
    
    static var shared: Cart = {
        return Cart()
    }()
    
    private init() {}
    
    mutating func addProductToCart(product: Product, quantity: Int) {
        if products[product] != nil {
            products[product]! += quantity
        } else {
            products[product] = quantity
        }
    }
    
    mutating func removeProductFromCart(product: Product, quantity: Int = 0) {
        if products[product] != nil {
            if products[product]! >= 0 {
                if quantity == 0 || products[product]! - quantity <= 0 {
                    products[product] = nil
                } else {
                    products[product]! -= quantity
                }
            }
        }
    }
    
    mutating func removeAllProductsFromCart() {
        products.removeAll()
    }
    
    func getProducts(at offsets: IndexSet) -> [Product] {
        let productsArray = Array(self.products.keys)
        
        let productsIDsToDelete = offsets.map {
            productsArray[$0].id
        }
        
        return productsArray.filter {
            productsIDsToDelete.contains($0.id)
        }
    }
    
    func getCartProductCount(product: Product) -> Int {
        if let productCount = products[product] {
            return productCount
        } else {
            return 0
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
