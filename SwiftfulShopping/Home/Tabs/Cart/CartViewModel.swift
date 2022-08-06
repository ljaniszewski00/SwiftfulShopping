//
//  CartViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var cart: Cart = Cart.shared
    
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var shouldPresentCheckoutFirstView: Bool = false
    
    func restorePreviousCart() {
        if let cartProductsIDsFromDefaults = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            let cartProductsIDs = Array(cartProductsIDsFromDefaults.keys)
            for productID in cartProductsIDs {
                if let productForProductID = ProductsRepository.shared.getProductFor(productID: productID) {
                    self.cart.products[productForProductID] = cartProductsIDsFromDefaults[productID]
                }
            }
        }
    }
    
    var cartIsEmpty: Bool {
        cart.products.isEmpty
    }
    
    var cartProductsCount: Int {
        cart.getCartProductsCount()
    }
    
    var cartTotalCost: Double {
        cart.getCartTotalCost()
    }
    
    func getCartProductCount(product: Product) -> Int {
        cart.getCartProductCount(product: product)
    }
    
    func addProductToCart(product: Product, quantity: Int) {
        cart.addProductToCart(product: product, quantity: quantity)
        
        if let cartProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            if cartProductsIDsFromDefaults[product.id] != nil {
                var cartProductsIDsFromDefaultsTemp: [String: Int] = cartProductsIDsFromDefaults
                cartProductsIDsFromDefaultsTemp[product.id]! += quantity
                UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
            } else {
                var cartProductsIDsFromDefaultsTemp: [String: Int] = cartProductsIDsFromDefaults
                cartProductsIDsFromDefaultsTemp[product.id] = quantity
                UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
            }
        } else {
            UserDefaults.standard.set([product.id: quantity], forKey: UserDefaultsKeys.cart.rawValue)
        }
    }
    
    func removeProductFromCart(product: Product, quantity: Int = 0) {
        cart.removeProductFromCart(product: product, quantity: quantity)
        
        if let cartProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            if cartProductsIDsFromDefaults[product.id] != nil {
                var cartProductsIDsFromDefaultsTemp: [String: Int] = cartProductsIDsFromDefaults
                if cartProductsIDsFromDefaultsTemp[product.id]! - quantity <= 0 || quantity == 0 {
                    cartProductsIDsFromDefaultsTemp[product.id] = nil
                    if cartProductsIDsFromDefaultsTemp.isEmpty {
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cart.rawValue)
                    } else {
                        UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
                    }
                } else {
                    cartProductsIDsFromDefaultsTemp[product.id]! -= quantity
                    UserDefaults.standard.set(cartProductsIDsFromDefaultsTemp, forKey: UserDefaultsKeys.cart.rawValue)
                }
            }
        }
    }
    
    func removeProducts(at offsets: IndexSet) {
        if let productToBeRemoved = cart.getProduct(at: offsets) {
            removeProductFromCart(product: productToBeRemoved, quantity: 0)
        }
    }
    
    func removeAllProductsFromCart() {
        cart.removeAllProductsFromCart()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cart.rawValue)
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
}
