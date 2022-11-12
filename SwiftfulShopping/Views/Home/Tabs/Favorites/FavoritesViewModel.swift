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
        favoriteProducts.append(product)
        UserDefaults.standard.set(favoriteProducts.map { $0.id }, forKey: UserDefaultsKeys.favorites.rawValue)
        fetchFavorites()
    }
    
    func removeFromFavorites(product: Product) {
        for (index, favoriteProduct) in favoriteProducts.enumerated() where favoriteProduct.id == product.id {
            favoriteProducts.remove(at: index)
            break
        }
        UserDefaults.standard.set(favoriteProducts.map { $0.id }, forKey: UserDefaultsKeys.favorites.rawValue)
        fetchFavorites()
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
}
