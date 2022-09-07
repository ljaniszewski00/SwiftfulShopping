//
//  ExploreViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    @Published var errorManager = ErrorManager.shared
    
    @Published var productsFromRepository: [Product] = []
    @Published var productsToBeDisplayed: [Product] = []
    
    @Published var selectedTab: ExploreViewTabs = .trending
    @Published var productsForTab: TabsWithProducts = .exploreView
    @Published var displayOnlyRecommended: Bool = false
    @Published var displayedCategory: Category?
    @Published var choosenProduct: Product?
    
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    @Published var searchProductsText: String = ""
    
    @Published var presentSortingAndFilteringSheet: Bool = false
    
    @Published var scrollProductsListToBeginning: Bool = false
    @Published var tabsSize: CGSize = .zero
    @Published var productTileSize: CGSize = .zero
    
    var productsCompanies: [String] {
        var companies: Set<String> = []
        for product in productsFromRepository {
            companies.insert(product.company)
        }
        return Array(companies).sorted(by: { $0 > $1 })
    }
    
    var productsCategories: [Category] {
        var categories: Set<Category> = []
        for product in productsFromRepository {
            categories.insert(product.category)
        }
        return Array(categories).sorted(by: { $0.rawValue > $1.rawValue })
    }
    
    func fetchProducts() {
        showLoadingModal = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.productsFromRepository = ProductsRepository.shared.products
            self?.productsToBeDisplayed = ProductsRepository.shared.products
            self?.showLoadingModal = false
        }
    }
    
    var changingProductsToBeDisplayed: [Product] {
        get {
            switch productsForTab {
            case .exploreView:
                switch selectedTab {
                case .trending:
                    return productsToBeDisplayed
                case .categories:
                    return productsByCategory
                case .weRecommend:
                    return recommendedProducts
                }
            case .searchView:
                return productsToBeDisplayedBySearch
            }
        }
        
        set {
            productsToBeDisplayed = newValue
        }
    }
    
    private var recommendedProducts: [Product] {
        return productsToBeDisplayed.filter {
            $0.isRecommended
        }
    }
    
    private var productsByCategory: [Product] {
        if let displayedCategory = displayedCategory {
            return productsToBeDisplayed.filter {
                $0.category == displayedCategory
            }
        } else {
            return productsToBeDisplayed
        }
    }
    
    private var productsToBeDisplayedBySearch: [Product] {
        productsToBeDisplayed.filter {
            $0.name.lowercased().contains(searchProductsText.lowercased()) ||
            $0.company.lowercased().contains(searchProductsText.lowercased())
        }
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func restoreOriginalProductsArray() {
        changingProductsToBeDisplayed = productsFromRepository
    }
    
    func getProductsListFor(recognitionResults: [String]) -> [Product] {
        var products: Set<Product> = []
        for recognitionResult in recognitionResults {
            for productFromRepository in productsFromRepository {
                for keyword in productFromRepository.keywords {
                    if keyword.lowercased().contains(recognitionResult.lowercased()) {
                        products.insert(productFromRepository)
                    }
                }
            }
        }
        
        return Array(products)
    }
}
