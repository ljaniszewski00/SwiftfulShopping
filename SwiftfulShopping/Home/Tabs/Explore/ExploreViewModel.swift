//
//  ExploreViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var allProducts: [Product] = []
    @Published var selectedTab: ExploreViewTabs = .trending
    @Published var displayOnlyRecommended: Bool = false
    @Published var displayedCategory: Category?
    @Published var choosenProduct: Product?
    @Published var displayMethod: ProductDisplayMethod = .list
    
    @Published var shouldPresentProductDetailsView: Bool = false
    
    func fetchProducts() {
        self.allProducts = ProductsRepository.shared.products
    }
    
    var recommendedProducts: [Product] {
        return allProducts.filter {
            $0.isRecommended
        }
    }
    
    var productsByCategory: [Product] {
        if let displayedCategory = displayedCategory {
            return allProducts.filter {
                $0.category == displayedCategory
            }
        } else {
            return allProducts
        }
        
    }
    
    var productsToBeDisplayed: [Product] {
        if selectedTab == .weRecommend {
            return recommendedProducts
        } else {
            if selectedTab == .categories {
                return productsByCategory
            } else {
                return allProducts
            }
        }
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func changeDisplayMethodFor(displayMethod: ProductDisplayMethod) {
        self.displayMethod = displayMethod
    }
    
    func calculateProductAverageRating(product: Product) -> Double {
        var overallRating: Double = 0
        var ratingsNumber: Int = 0
        for ratingNumber in Array(product.ratings.keys) {
            if product.ratings[ratingNumber]!.count > 0 {
                overallRating += Double(ratingNumber * product.ratings[ratingNumber]!.count)
                ratingsNumber += product.ratings[ratingNumber]!.count
            }
        }
        return overallRating / Double(ratingsNumber)
    }
    
    func getProductRatingsCount(product: Product) -> Int {
        var ratingsNumber: Int = 0
        for rating in Array(product.ratings.keys) {
            ratingsNumber += product.ratings[rating]!.count
        }
        return ratingsNumber
    }
}
