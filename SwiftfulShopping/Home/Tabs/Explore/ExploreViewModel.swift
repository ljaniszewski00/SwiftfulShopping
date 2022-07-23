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
    @Published var currentProduct: Product?
    @Published var displayMethod: ProductDisplayMethod = .list
    
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var productQuantityToBasket: Int = 1
    
    init() {
        allProducts = Product.demoProducts
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
        currentProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func changeDisplayMethodFor(displayMethod: ProductDisplayMethod) {
        self.displayMethod = displayMethod
    }
    
    func addOneProduct() {
        productQuantityToBasket += 1
    }
    
    func removeOneProduct() {
        productQuantityToBasket -= 1
    }
}
