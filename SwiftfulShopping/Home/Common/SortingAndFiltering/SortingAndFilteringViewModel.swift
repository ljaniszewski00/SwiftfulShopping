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
    @Published var companyFiltersToApply: [String] = []
    @Published var companyFiltersApplied: [String] = []
    
    @Published var categoryFilterSectionHidden: Bool = false
    @Published var categoryFiltersToApply: [Category] = []
    @Published var categoryFiltersApplied: [Category] = []
    
    @Published var priceFilterSectionHidden: Bool = false
    @Published var lowestPriceFilter: String = ""
    @Published var highestPriceFilter: String = ""
    
    @Published var ratingFilterSectionHidden: Bool = false
    @Published var lowestRatingFilter: Int = 0
    @Published var highestRatingFilter: Int = 0
    
    //General
    var applyFiltersButtonVisible: Bool {
        if !filteringApplied {
            return !companyFiltersToApply.isEmpty ||
            !categoryFiltersToApply.isEmpty ||
            !lowestPriceFilter.isEmpty || !highestPriceFilter.isEmpty ||
            lowestRatingFilter > 0 || highestRatingFilter > 0
        } else {
            return true
        }
    }
    
    var numberOfFiltersApplied: Int {
        if filteringApplied {
            var count: Int = 0
            
            count += companyFiltersApplied.count
            count += categoryFiltersApplied.count
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
        } else {
            return 0
        }
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
        filteringMethodsToApply.removeAll()
        filteringApplied = false
        
        if companyFiltersToApply.isEmpty {
            companyFiltersToApply = companyFiltersApplied
        } else {
            filteringMethodsToApply.insert(.company)
            companyFiltersApplied = companyFiltersToApply
        }
        if categoryFiltersToApply.isEmpty {
            categoryFiltersToApply = categoryFiltersApplied
        } else {
            filteringMethodsToApply.insert(.category)
            categoryFiltersApplied = categoryFiltersToApply
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
                    companyFiltersToApply.contains($0.company)
                }
            case .category:
                productsArray = productsArray.filter {
                    categoryFiltersToApply.contains($0.category)
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
            filteringApplied = true
        }
    }
    
    func applySorting(productsArray: inout [Product]) {
        sortingApplied = true
        sortProducts(productsArray: &productsArray)
    }
    
    func applyFiltering(productsArray: inout [Product]) {
        filterProducts(productsArray: &productsArray)
    }
    
    func manageCompanyFiltersFor(company: String) {
        if companyFiltersToApply.contains(company) {
            for (index, companyFilter) in companyFiltersToApply.enumerated() where companyFilter == company {
                companyFiltersToApply.remove(at: index)
            }
        } else {
            companyFiltersToApply.append(company)
        }
    }
    
    func manageCategoryFiltersFor(category: Category) {
        if categoryFiltersToApply.contains(category) {
            for (index, categoryFilter) in categoryFiltersToApply.enumerated() where categoryFilter == category {
                categoryFiltersToApply.remove(at: index)
            }
        } else {
            categoryFiltersToApply.append(category)
        }
    }
    
    private func restoreDefaultSortingValues() {
        sortingApplied = false
        sortingMethod = .popularity
    }
    
    private func restoreDefaultFilteringValues() {
        filteringApplied = false
        filteringMethodsToApply.removeAll()
        
        companyFiltersToApply.removeAll()
        companyFiltersApplied.removeAll()
        categoryFiltersToApply.removeAll()
        categoryFiltersApplied.removeAll()
        lowestPriceFilter = ""
        highestPriceFilter = ""
        lowestRatingFilter = 0
        highestRatingFilter = 0
    }
    
    private func restoreLastFilteringValues() {
        companyFiltersToApply = companyFiltersApplied
        categoryFiltersToApply = categoryFiltersApplied
    }
    
    func sheetDismissedWithNoFilteringApplied(originalProductsArray: [Product], currentProductsArray: inout [Product]) {
        if !filteringApplied {
            restoreLastFilteringValues()
            
            restoreDefaults(originalProductsArray: originalProductsArray, currentProductsArray: &currentProductsArray)
        }
    }
    
    func restoreDefaults(originalProductsArray: [Product], currentProductsArray: inout [Product]) {
        restoreDefaultSortingValues()
        restoreDefaultFilteringValues()
        currentProductsArray = originalProductsArray
    }
}
