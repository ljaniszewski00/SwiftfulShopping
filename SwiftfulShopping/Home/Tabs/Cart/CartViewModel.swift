//
//  CartViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var cart: Cart = Cart.shared
    
    func restorePreviousCart() {
        if let cartProductsIDsFromDefaults = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            for key in cartProductsIDsFromDefaults {
                print(key)
            }
            let cartProductsIDs = Array(cartProductsIDsFromDefaults.keys)
            for productID in cartProductsIDs {
                if let productForProductID = ProductsRepository.shared.getProductFor(productID: productID) {
                    self.cart.products[productForProductID] = cartProductsIDsFromDefaults[productID]
                }
            }
        }
    }
    
    var cartProductsCount: Int {
        cart.getCartProductsCount()
    }
    
    var cartTotalCost: Double {
        cart.getCartTotalCost()
    }
    
    func getCartProductCount(productID: String) -> Int {
        cart.getCartProductCount(productID: productID)
    }
    
    func addProductToCart(productID: String, quantity: Int) {
        cart.addProductToCart(productID: productID, quantity: quantity)
        
        if let cartProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            if cartProductsIDsFromDefaults[productID] != nil {
                var cartProductsIDsFromDefaultsTemp: [String: Int] = cartProductsIDsFromDefaults
                cartProductsIDsFromDefaultsTemp[productID]! += quantity
                UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
            } else {
                var cartProductsIDsFromDefaultsTemp: [String: Int] = cartProductsIDsFromDefaults
                cartProductsIDsFromDefaultsTemp[productID] = quantity
                UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
            }
        } else {
            UserDefaults.standard.set([productID: quantity], forKey: UserDefaultsKeys.cart.rawValue)
        }
    }
    
    func removeProductFromCart(productID: String, quantity: Int = 0) {
        cart.removeProductFromCart(productID: productID, quantity: quantity)
        
        if let cartProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            if cartProductsIDsFromDefaults[productID] != nil {
                var cartProductsIDsFromDefaultsTemp: [String: Int] = cartProductsIDsFromDefaults
                if cartProductsIDsFromDefaultsTemp[productID]! - quantity < 0 || quantity == 0 {
                    cartProductsIDsFromDefaultsTemp[productID] = nil
                    if cartProductsIDsFromDefaultsTemp.isEmpty {
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cart.rawValue)
                    }
                } else {
                    cartProductsIDsFromDefaultsTemp[productID]! -= quantity
                }
                
                UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
            }
        }
        
        print(cart.products)
    }
    
    func removeAllProductsFromCart() {
        cart.removeAllProductsFromCart()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cart.rawValue)
    }
}
