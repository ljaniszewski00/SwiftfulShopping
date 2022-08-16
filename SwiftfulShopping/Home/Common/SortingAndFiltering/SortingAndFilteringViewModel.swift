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
    @Published var filteringSectionHidden: Bool = false
    @Published var filteringApplied: Bool = false
    @Published var filteringMethodsToApply: Set<FilteringMethods> = []
    
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
    
    //General
    var sortingOrFilteringApplied: Bool {
        sortingApplied || filteringApplied
    }
    
    var applyFiltersButtonVisible: Bool {
        !companyFilters.isEmpty ||
        !categoryFilters.isEmpty ||
        !lowestPriceFilter.isEmpty || !highestPriceFilter.isEmpty ||
        lowestRatingFilter > 0 || highestRatingFilter > 0
    }
    
    var numberOfFiltersApplied: Int {
        var count: Int = 0
        
        count += companyFilters.count
        count += categoryFilters.count
        if !lowestPriceFilter.isEmpty {
            count += 1
        }
        if !highestPriceFilter.isEmpty {
            count += 1
        }
        if lowestRatingFilter > 0 {
            count += 1
        }
        if highestRatingFilter > 0 {
            count += 1
        }
        
        return count
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
//        filteringMethodsToApply.removeAll()
        
        if !companyFilters.isEmpty {
            filteringMethodsToApply.insert(.company)
        }
        if !categoryFilters.isEmpty {
            filteringMethodsToApply.insert(.category)
        }
        if !lowestPriceFilter.isEmpty || !highestPriceFilter.isEmpty {
            filteringMethodsToApply.insert(.price)
        }
        if lowestRatingFilter > 0 || highestRatingFilter > 0 {
            filteringMethodsToApply.insert(.rating)
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
                print("here")
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
        sortingApplied = false
        sortingMethod = .popularity
    }
    
    private func restoreDefaultFilteringValues() {
        filteringApplied = false
        filteringMethodsToApply.removeAll()
        
        companyFilters.removeAll()
        categoryFilters.removeAll()
        lowestPriceFilter = ""
        highestPriceFilter = ""
        lowestRatingFilter = 0
        highestRatingFilter = 0
    }
    
    func restoreDefaults(originalProductsArray: [Product], currentProductsArray: inout [Product]) {
        restoreDefaultSortingValues()
        restoreDefaultFilteringValues()
        currentProductsArray = originalProductsArray
    }
}
