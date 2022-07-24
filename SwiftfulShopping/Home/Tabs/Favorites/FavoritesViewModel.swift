//
//  FavoritesViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    
    var favoriteProductsIDs: [String] {
        var favoriteProductsIDs: [String] = []
        for favoriteProduct in favoriteProducts {
            favoriteProductsIDs.append(favoriteProduct.id)
        }
        return favoriteProductsIDs
    }
    
    func fetchFavorites() {
        if let favoriteProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorites.rawValue) as? [String] {
            self.favoriteProducts = ProductsRepository.shared.products.filter {
                favoriteProductsIDsFromDefaults.contains($0.id)
            }
        }
    }
    
    func manageFavoritesFor(product: Product) {
        if favoriteProductsIDs.contains(product.id) {
            var favoriteProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorites.rawValue) as? [String]
            for (index, productIDFromDefaults) in favoriteProductsIDsFromDefaults!.enumerated() {
                if productIDFromDefaults == product.id {
                    favoriteProductsIDsFromDefaults!.remove(at: index)
                    break
                }
            }
            UserDefaults.standard.set(favoriteProductsIDsFromDefaults, forKey: UserDefaultsKeys.favorites.rawValue)
        } else {
            var favoriteProductsIDsFromDefaults = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorites.rawValue) as? [String]
            if favoriteProductsIDsFromDefaults == nil {
                UserDefaults.standard.set([product.id], forKey: UserDefaultsKeys.favorites.rawValue)
            } else {
                favoriteProductsIDsFromDefaults!.append(product.id)
                UserDefaults.standard.set(favoriteProductsIDsFromDefaults, forKey: UserDefaultsKeys.favorites.rawValue)
            }
        }
        fetchFavorites()
    }
}
