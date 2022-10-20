//
//  FavoritesViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    func fetchFavorites() {
        if let favoriteProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorites.rawValue) as? [String],
            let productsFromRepository = ProductsRepository.shared.products {
            self.favoriteProducts = productsFromRepository.filter {
                favoriteProductsIDsFromDefaults.contains($0.id)
            }
        }
    }
    
    func addToFavorites(product: Product) {
        var favoriteProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorites.rawValue) as? [String]
        if favoriteProductsIDsFromDefaults == nil {
            UserDefaults.standard.set([product.id], forKey: UserDefaultsKeys.favorites.rawValue)
        } else {
            favoriteProductsIDsFromDefaults!.append(product.id)
            UserDefaults.standard.set(favoriteProductsIDsFromDefaults, forKey: UserDefaultsKeys.favorites.rawValue)
        }
        favoriteProducts.append(product)
        fetchFavorites()
    }
    
    func removeFromFavorites(product: Product) {
        var favoriteProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorites.rawValue) as? [String]
        for (index, productIDFromDefaults) in favoriteProductsIDsFromDefaults!.enumerated() {
            if productIDFromDefaults == product.id {
                favoriteProductsIDsFromDefaults!.remove(at: index)
                break
            }
        }
        UserDefaults.standard.set(favoriteProductsIDsFromDefaults, forKey: UserDefaultsKeys.favorites.rawValue)
        for (index, favoriteProduct) in favoriteProducts.enumerated() where favoriteProduct.id == product.id {
            favoriteProducts.remove(at: index)
            break
        }
        fetchFavorites()
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
}
