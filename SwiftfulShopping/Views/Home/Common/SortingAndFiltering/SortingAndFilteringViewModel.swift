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
        var productsAverageRatings: [Product: Double] = [:]
        var productsRatingsNumber: [Product: Int] = [:]
        var productsReviewsNumber: [Product: Int] = [:]
        
        for product in productsArray {
            if let ratings = RatingsRepository.shared.ratings {
                let productRatings = ratings.filter { $0.productID == product.id }
                
                productsAverageRatings[product] = Double((productRatings.map { $0.rating }.reduce(0, +)) / productRatings.count)
                productsRatingsNumber[product] = productRatings.count
                productsReviewsNumber[product] = productRatings.filter { $0.review != nil }.map { $0.review }.count
            }
        }
        
        switch sortingMethod {
        case .priceAscending:
            productsArray = productsArray.sorted(by: { guard let firstPrice = $0.price, let secondPrice = $1.price else { return true }; return firstPrice < secondPrice })
        case .priceDescending:
            productsArray = productsArray.sorted(by: { guard let firstPrice = $0.price, let secondPrice = $1.price else { return true }; return firstPrice > secondPrice })
        case .popularity:
            productsArray = productsArray.sorted(by: { $0.unitsSold > $1.unitsSold })
        case .ratingAscending:
            productsArray = productsArray.sorted(by: {
                productsAverageRatings[$0] ?? 0 < productsAverageRatings[$1] ?? 0
            })
        case .ratingDescending:
            productsArray = productsArray.sorted(by: {
                productsAverageRatings[$0] ?? 0 > productsAverageRatings[$1] ?? 0
            })
        case .reviewsAscending:
            productsArray = productsArray.sorted(by: {
                productsReviewsNumber[$0] ?? 0 < productsReviewsNumber[$1] ?? 0
            })
        case .reviewsDescending:
            productsArray = productsArray.sorted(by: {
                productsReviewsNumber[$0] ?? 0 > productsReviewsNumber[$1] ?? 0
            })
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
                    productsArray = productsArray.filter { guard let price = $0.price else { return true }; return price >= doubleLowestPriceFilter }
                }
                if let doubleHighestPriceFilter = Double(highestPriceFilter) {
                    productsArray = productsArray.filter { guard let price = $0.price else { return true }; return price <= doubleHighestPriceFilter }
                }
            case .rating:
                var productsAverageRatings: [Product: Double] = [:]
                
                for product in productsArray {
                    if let ratings = RatingsRepository.shared.ratings {
                        let productRatings = ratings.filter { $0.productID == product.id }
                        
                        productsAverageRatings[product] = Double((productRatings.map { $0.rating }.reduce(0, +)) / productRatings.count)
                    }
                }
                
                if lowestRatingFilter > 0 {
                    productsArray = productsArray.filter {
                        productsAverageRatings[$0] ?? 0 >= Double(lowestRatingFilter)
                    }
                }
                
                if highestRatingFilter > 0 {
                    productsArray = productsArray.filter {
                        productsAverageRatings[$0] ?? 0 <= Double(highestRatingFilter)
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
            if let indexToRemove = companyFiltersToApply.firstIndex(of: company) {
                companyFiltersToApply.remove(at: indexToRemove)
            }
        } else {
            companyFiltersToApply.append(company)
        }
    }
    
    func manageCategoryFiltersFor(category: Category) {
        if categoryFiltersToApply.contains(category) {
            if let indexToRemove = categoryFiltersToApply.firstIndex(of: category) {
                categoryFiltersToApply.remove(at: indexToRemove)
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
