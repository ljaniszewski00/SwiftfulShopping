//
//  SortingAndFilteringViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 15/08/2022.
//

import Foundation

class SortingAndFilteringViewModel: ObservableObject {
    //Sorting
    @Published var sortingApplied: Bool = false
    @Published var sortingMethod: SortingMethods = .popularity
    @Published var sortingSectionHidden: Bool = false
    
    //Filtering
    @Published var filteringApplied: Bool = false
    @Published var filteringMethodsToApply: [FilteringMethods] = []
    
    @Published var companyFilterSectionHidden: Bool = false
    @Published var companyFilters: [String] = []
    
    @Published var categoryFilterSectionHidden: Bool = false
    @Published var categoryFilters: [Category] = []
    
    @Published var priceFilterSectionHidden: Bool = false
    @Published var lowestPriceFilter: String = ""
    @Published var highestPriceFilter: String = ""
    
    @Published var ratingFilterSectionHidden: Bool = false
    @Published var lowestRatingFilter: Int = 0
    @Published var highestRatingFilter: Int = 0
    
    @Published var filteringSectionHidden: Bool = false
    
    //General
    var sortingOrFilteringApplied: Bool {
        sortingApplied || filteringApplied
    }
    
    private func sortProducts(productsArray: inout [Product]) {
        switch sortingMethod {
        case .priceAscending:
            productsArray = productsArray.sorted(by: { $0.price < $1.price })
        case .priceDescending:
            productsArray = productsArray.sorted(by: { $0.price > $1.price })
        case .popularity:
            productsArray = productsArray.sorted(by: { $0.unitsSold > $1.unitsSold })
        case .ratingAscending:
            productsArray = productsArray.sorted(by: { $0.rating.averageRating < $1.rating.averageRating })
        case .ratingDescending:
            productsArray = productsArray.sorted(by: { $0.rating.averageRating > $1.rating.averageRating })
        case .reviewsAscending:
            productsArray = productsArray.sorted(by: { $0.rating.reviewsNumber < $1.rating.reviewsNumber })
        case .reviewsDescending:
            productsArray = productsArray.sorted(by: { $0.rating.reviewsNumber > $1.rating.reviewsNumber })
        }
    }
    
    private func filterProducts(productsArray: inout [Product]) {
        if !companyFilters.isEmpty {
            filteringMethodsToApply.append(.company)
        }
        if !categoryFilters.isEmpty {
            filteringMethodsToApply.append(.category)
        }
        if !lowestPriceFilter.isEmpty || !highestPriceFilter.isEmpty {
            filteringMethodsToApply.append(.price)
        }
        if lowestRatingFilter > 0 || highestRatingFilter > 0 {
            filteringMethodsToApply.append(.rating)
        }
        
        for filteringMethod in filteringMethodsToApply {
            switch filteringMethod {
            case .company:
                productsArray = productsArray.filter {
                    companyFilters.contains($0.company)
                }
            case .category:
                productsArray = productsArray.filter {
                    categoryFilters.contains($0.category)
                }
            case .price:
                if let doubleLowestPriceFilter = Double(lowestPriceFilter) {
                    productsArray = productsArray.filter {
                        $0.price >= doubleLowestPriceFilter
                    }
                }
                if let doubleHighestPriceFilter = Double(highestPriceFilter) {
                    productsArray = productsArray.filter {
                        $0.price <= doubleHighestPriceFilter
                    }
                }
            case .rating:
                if lowestRatingFilter > 0 {
                    productsArray = productsArray.filter {
                        $0.rating.averageRating >= Double(lowestRatingFilter)
                    }
                }
                
                if highestRatingFilter > 0 {
                    productsArray = productsArray.filter {
                        $0.rating.averageRating <= Double(highestRatingFilter)
                    }
                }
            }
        }
    }
    
    private func applySorting(productsArray: inout [Product]) {
        sortingApplied = true
        sortProducts(productsArray: &productsArray)
    }
    
    private func applyFiltering(productsArray: inout [Product]) {
        filteringApplied = true
        filterProducts(productsArray: &productsArray)
    }
    
    func manageCompanyFiltersFor(company: String) {
        if companyFilters.contains(company) {
            for (index, companyFilter) in companyFilters.enumerated() where companyFilter == company {
                companyFilters.remove(at: index)
            }
        } else {
            companyFilters.append(company)
        }
    }
    
    func manageCategoryFiltersFor(category: Category) {
        if categoryFilters.contains(category) {
            for (index, categoryFilter) in categoryFilters.enumerated() where categoryFilter == category {
                categoryFilters.remove(at: index)
            }
        } else {
            categoryFilters.append(category)
        }
    }
    
    func applySortingAndFiltering(productsArray: inout [Product]) {
        applySorting(productsArray: &productsArray)
        applyFiltering(productsArray: &productsArray)
    }
    
    private func restoreDefaultSortingValues() {
        sortingMethod = .popularity
    }
    
    private func restoreDefaultFileringValues() {
        companyFilters.removeAll()
        categoryFilters.removeAll()
        lowestPriceFilter = ""
        highestPriceFilter = ""
        lowestRatingFilter = 0
        highestRatingFilter = 0
    }
    
    func restoreDefaults(originalProductsArray: [Product], currentProductsArray: inout [Product]) {
        restoreDefaultSortingValues()
        restoreDefaultFileringValues()
        currentProductsArray = originalProductsArray
    }
}
