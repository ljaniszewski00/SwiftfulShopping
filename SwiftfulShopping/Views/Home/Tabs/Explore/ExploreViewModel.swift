//
//  ExploreViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import Foundation
import UIKit
import Kingfisher

class ExploreViewModel: ObservableObject {
    @Published var errorManager = ErrorManager.shared
    
    @Published var productsFromRepository: [Product] = []
    @Published var productsToBeDisplayed: [Product] = []
    @Published var ratingsFromRepository: [ProductRating] = []
    
    @Published var productsToBeDisplayedBySearch: [Product] = []
    
    @Published var productsToBeCompared: [Product] = []
    
    @Published var categoriesWithImages: [Category: UIImage] = [:]
    
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
    @Published var shouldPresentProductDetailsViewFromProductsListView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    @Published var searchProductsText: String = ""
    
    @Published var presentSortingAndFilteringSheet: Bool = false
    
    @Published var scrollProductsListToBeginning: Bool = false
    @Published var categoriesTileSize: CGSize = .zero
    
    func fetchData(completion: @escaping (() -> ())) {
        fetchProducts { [weak self] in
            self?.fetchRatings {
                self?.getCategoriesImages {
                    completion()
                }
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
    
    var firstNewestProducts: [Product] {
        let filteredProducts = productsFromRepository
            .filter { $0.isNew }
        
        let filteredProductsCount = filteredProducts.count
        
        switch filteredProductsCount {
        case _ where filteredProductsCount > 0 && filteredProductsCount <= 3:
            return Array(filteredProducts.prefix(filteredProductsCount))
        case _ where filteredProductsCount > 3:
            return Array(filteredProducts.prefix(3))
        default:
            return []
        }
    }
    
    var allNewestProducts: [Product] {
        return productsFromRepository
            .filter { $0.isNew }
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
    
    var firstRecommendedProducts: [Product] {
        let filteredProducts = productsFromRepository
            .filter { $0.isRecommended }
        
        let filteredProductsCount = filteredProducts.count
        
        switch filteredProductsCount {
        case _ where filteredProductsCount > 0 && filteredProductsCount <= 3:
            return Array(filteredProducts.prefix(filteredProductsCount))
        case _ where filteredProductsCount > 3:
            return Array(filteredProducts.prefix(3))
        default:
            return []
        }
    }
    
    var allRecommendedProducts: [Product] {
        return productsFromRepository
            .filter { $0.isRecommended }
    }
    
    func getCategoriesImages(completion: @escaping (() -> ())) {
        let dispatchGroup = DispatchGroup()
        
        for category in productsCategories {
            dispatchGroup.enter()
            let categoryImageURLString = productsFromRepository
                                            .filter { $0.category == category }
                                            .map { $0.imagesURLs.first }
                                            .compactMap { $0 }
                                            .first
            
            if let categoryImageURLString = categoryImageURLString, let url = URL(string: categoryImageURLString) {
                
                KingfisherManager.shared.retrieveImage(with: url, options: [.lowDataMode(.network(url))]) { [weak self] result in
                    switch result {
                    case .success(let value):
                        self?.categoriesWithImages[category] = value.image
                    case .failure(_):
                        break
                    }
                    dispatchGroup.leave()
                }
            } else {
                self.categoriesWithImages[category] = UIImage(named: AssetsNames.productPlaceholder)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
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
                    return allNewestProducts.sorted { $0.name < $1.name }
                case .company:
                    return companyProducts.sorted { $0.name < $1.name }
                case .recommended:
                    return allRecommendedProducts.sorted { $0.name < $1.name }
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
    
    func getProductsToBeDisplayedBySearch() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let results = self?.productsFromRepository
                            .lazy
                            .filter {
                                $0.keywords
                                    .map { $0.lowercased() }
                                    .compactMap { $0 }
                                    .uniqued()
                                    .contains { $0.contains(self?.searchProductsText.lowercased() ?? "") }
                            }
            
            if let results = results {
                DispatchQueue.main.async { [weak self] in
                    self?.productsToBeDisplayedBySearch = results.compactMap({ product in
                        return product
                    })
                }
            }
        }
    }
    
    func getProductSpecificationForProductDetails(product: Product) -> [String: String]? {
        if let languageCode = Locale.current.languageCode, let productSpecification = product.specification[languageCode] {
            return Dictionary(uniqueKeysWithValues: productSpecification.map { (key, value) in (key.rawValue, value) })
        } else {
            return nil
        }
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
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
    
    var productsToBeComparedCategory: Category? {
        productsToBeCompared.first?.category
    }
    
    func addProductToBeCompared(product: Product) -> Bool {
        /// Product can be added to comparison array if:
        /// - it is not present in comparison array
        /// - it has the same category as other products in array
        /// - comparison array already contains less than 5 products
        
        if productsToBeCompared.isEmpty {
            productsToBeCompared.append(product)
            return true
        } else {
            if let productsToBeComparedCategory = productsToBeComparedCategory {
                if product.category == productsToBeComparedCategory &&
                    productsToBeCompared.count < 5 &&
                    !productsToBeCompared.contains(product) {
                    productsToBeCompared.append(product)
                    return true
                }
            }
            
            return false
        }
    }
    
    func removeProductToBeCompared(product: Product) {
        if let productIndex = productsToBeCompared.firstIndex(of: product) {
            productsToBeCompared.remove(at: productIndex)
        }
    }
    
    func removeAllProductsFromComparison() {
        productsToBeCompared.removeAll()
    }
}
