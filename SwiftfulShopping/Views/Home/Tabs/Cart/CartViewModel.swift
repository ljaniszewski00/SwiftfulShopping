//
//  CartViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var availableDiscounts: [Discount] = []
    
    @Published var productsForCart: [Product: Int] = [:]
    @Published var appliedDiscounts: Set<Discount> = []
    
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var shouldPresentCheckoutFirstView: Bool = false
    
    func onAppear() {
        fetchData()
        restorePreviousCart()
    }
    
    func fetchData() {
        fetchDiscounts {}
    }
    
    func fetchDiscounts(completion: @escaping (() -> ())) {
        FirestoreProductsManager.client.getDiscounts { [weak self] result in
            switch result {
            case .success(let discounts):
                self?.availableDiscounts = discounts ?? []
            case .failure(_):
                completion()
            }
        }
    }
    
    func restorePreviousCart() {
        if let cartProductsIDsFromDefaults = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.cart.rawValue) as? [String: Int] {
            let cartProductsIDs = Array(cartProductsIDsFromDefaults.keys)
            for productID in cartProductsIDs {
                if let productForProductID = ProductsRepository.shared.products?.filter({ $0.id == productID }).first {
                    productsForCart[productForProductID] = cartProductsIDsFromDefaults[productID]
                }
            }
        }
    }
    
    var cartIsEmpty: Bool {
        productsForCart.isEmpty
    }
    
    var cartUniqueProductsCount: Int {
        productsForCart.keys.count
    }
    
    var cartAllProductsQuantityCount: Int {
        productsForCart.values.reduce(0, +)
    }
    
    var cartTotalCost: Double {
        var totalCost: Double = 0
        _ = productsForCart.map { product, quantity in
            totalCost += product.price * Double(quantity)
        }

        return totalCost
    }
    
    var cartTotalCostWithAppliedDiscounts: Double {
        var totalCostWithAppliedDiscounts = cartTotalCost
        _ = appliedDiscounts.map { discount in
            totalCostWithAppliedDiscounts *= (1 - (discount.discountValuePercent / 100))
        }
        return totalCostWithAppliedDiscounts
    }
    
    var sortedAppliedDiscounts: [Discount] {
        Array(appliedDiscounts).sorted { $0.discountValuePercent > $1.discountValuePercent }
    }
    
    func getCartProductCount(product: Product) -> Int {
        if let productCount = productsForCart[product] {
            return productCount
        } else {
            return 0
        }
    }
    
    func addProductToCart(product: Product, quantity: Int) {
        if productsForCart[product] != nil {
            productsForCart[product]! += quantity
        } else {
            productsForCart[product] = quantity
        }
        
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
        if productsForCart[product] != nil {
            if productsForCart[product]! >= 0 {
                if quantity == 0 || productsForCart[product]! - quantity <= 0 {
                    productsForCart[product] = nil
                } else {
                    productsForCart[product]! -= quantity
                }
            }
        }
        
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
    
    func removeAllProductsFromCart() {
        productsForCart.removeAll()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cart.rawValue)
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func applyDiscount(discountCode: String) -> Bool {
        if let desiredDiscount = availableDiscounts.filter({ $0.discountCode == discountCode }).first {
            if Array(productsForCart.keys).map({ $0.id }).contains(desiredDiscount.productID) {
                appliedDiscounts.insert(desiredDiscount)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func removeDiscount(discount: Discount) {
        appliedDiscounts.remove(discount)
    }
}
