//
//  ExploreViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import Foundation
import Combine

class ExploreViewModel: ObservableObject {
    @Published var errorManager = ErrorManager.shared
    
    @Published var allProducts: [Product] = []
    @Published var selectedTab: ExploreViewTabs = .trending
    @Published var displayOnlyRecommended: Bool = false
    @Published var displayedCategory: Category?
    @Published var choosenProduct: Product?
    @Published var displayMethod: ProductDisplayMethod = .list
    
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    func fetchProducts() {
        showLoadingModal = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.allProducts = ProductsRepository.shared.products
            self?.showLoadingModal = false
        }
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
}
