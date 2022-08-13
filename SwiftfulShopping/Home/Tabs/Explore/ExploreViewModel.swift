//
//  ExploreViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    @Published var errorManager = ErrorManager.shared
    
    @Published var allProducts: [Product] = []
    @Published var selectedTab: ExploreViewTabs = .trending
    @Published var displayOnlyRecommended: Bool = false
    @Published var displayedCategory: Category?
    @Published var choosenProduct: Product?
    
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    @Published var searchProductsText: String = ""
    
    @Published var presentSortingAndFilteringSheet: Bool = false
    
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
        switch selectedTab {
        case .trending:
            return allProducts
        case .categories:
            return productsByCategory
        case .weRecommend:
            return recommendedProducts
        }
    }
        
    var productsToBeDisplayedBySearch: [Product] {
        allProducts.filter {
            $0.name.lowercased().contains(searchProductsText.lowercased()) ||
            $0.company.lowercased().contains(searchProductsText.lowercased())
        }
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
}
