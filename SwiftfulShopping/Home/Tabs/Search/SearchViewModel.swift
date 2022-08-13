//
//  SearchViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var trendingSearchesFullList: [String] = []
    var trendingSearches: [String] {
        Array(trendingSearchesFullList.prefix(4))
    }
    @Published var shouldPresentAllTrendingSearches: Bool = false
    
    @Published var recentSearchesFullList: [String] = []
    var recentSearches: [String] {
        Array(recentSearchesFullList.prefix(4))
    }
    @Published var shouldPresentAllRecentSearches: Bool = false
    
    func onAppear() {
        fetchTrendingSearches()
        fetchRecentSearches()
    }
    
    func fetchTrendingSearches() {
        self.trendingSearchesFullList = ["iPhone", "iPad", "MacBook", "Apple Watch", "Home Pod", "Apple VR", "Apple Car"]
    }
    
    func fetchRecentSearches() {
        self.recentSearchesFullList = ["iPhone", "iPad", "MacBook", "Apple Watch", "Home Pod", "Apple VR", "Apple Car"]
    }
    
    func removeRecentSearches() {
        recentSearchesFullList.removeAll()
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func addToRecentSearches(searchText: String) {
        if !recentSearchesFullList.contains(searchText) {
            recentSearchesFullList.append(searchText)
        }
    }
}
