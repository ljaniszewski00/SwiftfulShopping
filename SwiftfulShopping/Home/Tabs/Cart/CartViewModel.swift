//
//  CartViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var cart: Cart = Cart.shared
    
    var cartProductsCount: Int {
        cart.getCartProductsCount()
    }
    
    var cartTotalCost: Double {
        cart.getCartTotalCost()
    }
    
    func addProductToCart(product: Product, quantity: Int) {
        cart.addProductToCart(product: product, quantity: quantity)
    }
    
    func removeProductFromCart(product: Product, quantity: Int = 0) {
        cart.removeProductFromCart(product: product, quantity: quantity)
    }
}
