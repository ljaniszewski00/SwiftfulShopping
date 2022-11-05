//
//  ExploreViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var errorManager = ErrorManager.shared
    
    @Published var productsFromRepository: [Product] = []
    @Published var productsToBeDisplayed: [Product] = []
    @Published var ratingsFromRepository: [ProductRating] = []
    
    @Published var productsForTab: TabsWithProducts = .exploreView
    
    @Published var shouldPresentAllCategoryProducts: Bool = false
    @Published var choosenCategory: Category?
    @Published var shouldPresentAllNewProducts: Bool = false
    @Published var shouldPresentAllCompanyProducts: Bool = false
    @Published var choosenCompany: String?
    @Published var shouldPresentAllRecommendedProducts: Bool = false
    @Published var shouldPresentAllProducts: Bool = false
    @Published var productsForSource: ProductsListSource = .all
    
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    @Published var searchProductsText: String = ""
    
    @Published var presentSortingAndFilteringSheet: Bool = false
    
    @Published var scrollProductsListToBeginning: Bool = false
    @Published var categoriesTileSize: CGSize = .zero
    
    func fetchData(completion: @escaping (() -> ())) {
        fetchProducts { [weak self] in
            self?.fetchRatings {
                completion()
            }
        }
    }
    
    private func fetchProducts(completion: @escaping (() -> ())) {
        ProductsRepository.shared.fetchProducts { [weak self] products in
            if let products = products {
                self?.productsFromRepository = products
                self?.productsToBeDisplayed = products
            }
            completion()
        }
    }
    
    private func fetchRatings(completion: @escaping (() -> ())) {
        RatingsRepository.shared.fetchRatings { [weak self] productsRatings in
            if let productsRatings = productsRatings {
                self?.ratingsFromRepository = productsRatings
            }
            completion()
        }
    }
    
    var productsCategoriesWithImageURL: [Category: String?] {
        var productsCategoriesWithImageURL: [Category: String?] = [:]
        for category in productsCategories {
            productsCategoriesWithImageURL[category] = productsFromRepository
                                                            .filter { $0.category == category }
                                                            .map { $0.imagesURLs.first }
                                                            .compactMap { $0 }
                                                            .first
        }
        
        for (key, value) in productsCategoriesWithImageURL {
            if value == nil {
                productsCategoriesWithImageURL[key]
            }
        }
        
        return productsCategoriesWithImageURL
    }
    
    var productsWithRatings: [Product: [ProductRating]] {
        Dictionary(uniqueKeysWithValues: productsFromRepository.map { product in
            (product, ratingsFromRepository.filter { product.id == $0.productID })
        })
    }
    
    var productsCategories: [Category] {
        productsFromRepository
            .map { $0.category }
            .uniqued()
            .sorted { $0.decodeValue > $1.decodeValue }
    }
    
    private var categoryProducts: [Product] {
        if let choosenCategory = choosenCategory {
            return productsToBeDisplayed
                .filter { $0.category == choosenCategory }
        } else {
            return productsToBeDisplayed
        }
    }
    
    var newestProducts: [Product] {
        let filteredProducts = productsFromRepository.filter {
            $0.isNew
        }
        
        if shouldPresentAllNewProducts {
            return filteredProducts
        } else {
            let filteredProductsCount = filteredProducts.count
            if filteredProductsCount <= 0 {
                return []
            } else {
                if filteredProductsCount > 3 {
                    return Array(filteredProducts.prefix(3))
                } else {
                    return Array(filteredProducts.prefix(filteredProductsCount))
                }
            }
        }
    }
    
    var productsCompanies: [String] {
        var companies: Set<String> = []
        for product in productsFromRepository {
            companies.insert(product.company)
        }
        return Array(companies).sorted(by: { $0 > $1 })
    }
    
    private var companyProducts: [Product] {
        if let choosenCompany = choosenCompany {
            return productsToBeDisplayed.filter {
                $0.company.lowercased() == choosenCompany.lowercased()
            }
        } else {
            return productsToBeDisplayed
        }
    }
    
    var recommendedProducts: [Product] {
        let filteredProducts = productsFromRepository.filter {
            $0.isRecommended
        }
        
        if shouldPresentAllRecommendedProducts {
            return filteredProducts
        } else {
            let filteredProductsCount = filteredProducts.count
            if filteredProductsCount <= 0 {
                return []
            } else {
                if filteredProductsCount > 3 {
                    return Array(filteredProducts.prefix(3))
                } else {
                    return Array(filteredProducts.prefix(filteredProductsCount))
                }
            }
        }
    }
    
    func getRatingsFor(product: Product) -> [ProductRating] {
        ratingsFromRepository.filter { $0.productID == product.id }
    }
    
    var changingProductsToBeDisplayed: [Product] {
        get {
            switch productsForTab {
            case .exploreView:
                switch productsForSource {
                case .category:
                    return categoryProducts.sorted { $0.name < $1.name }
                case .newest:
                    return newestProducts.sorted { $0.name < $1.name }
                case .company:
                    return companyProducts.sorted { $0.name < $1.name }
                case .recommended:
                    return recommendedProducts.sorted { $0.name < $1.name }
                case .all:
                    return productsToBeDisplayed.sorted { $0.name < $1.name }
                }
            case .searchView:
                return productsToBeDisplayedBySearch.sorted { $0.name < $1.name }
            }
        }
        
        set {
            productsToBeDisplayed = newValue
        }
    }
    
    private var productsToBeDisplayedBySearch: [Product] {
        var products: Set<Product> = []
        
        for productFromRepository in productsFromRepository {
            for keyword in productFromRepository.keywords {
                if keyword.lowercased().contains(searchProductsText.lowercased()) {
                    products.insert(productFromRepository)
                    break
                }
            }
        }
        
        return Array(products).sorted { $0.name < $1.name }
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
                        break
                    }
                }
            }
        }
        
        return Array(products).sorted { $0.name < $1.name }
    }
}
