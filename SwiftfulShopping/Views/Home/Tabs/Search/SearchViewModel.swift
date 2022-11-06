//
//  SearchViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var shouldPresentProductRecognizerView: Bool = false
    
    @Published var shouldPresentImagePicker: Bool = false
    
    @Published var trendingSearchesFullList: [String] = []
    var trendingSearches: [String] {
        Array(trendingSearchesFullList.prefix(lengthOfShortTrendingAndRecentSearchesList))
    }
    @Published var shouldPresentAllTrendingSearches: Bool = false
    
    @Published var recentSearchesFullList: [String] = []
    var recentSearches: [String] {
        Array(recentSearchesFullList.prefix(lengthOfShortTrendingAndRecentSearchesList))
    }
    @Published var shouldPresentAllRecentSearches: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    @Published var scrollProductsListToBeginning: Bool = false
    @Published var filterAndDisplayPaneSize: CGSize = .zero
    @Published var productTileSize: CGSize = .zero
    
    var lengthOfShortTrendingAndRecentSearchesList: Int = 6
    
    var trendingSearchesSeeHideAllButtonVisible: Bool {
        !trendingSearchesFullList.isEmpty &&
        trendingSearchesFullList.count > lengthOfShortTrendingAndRecentSearchesList
    }
    
    var recentSearchesSeeHideAllButtonVisible: Bool {
        !recentSearchesFullList.isEmpty &&
        recentSearchesFullList.count > lengthOfShortTrendingAndRecentSearchesList
    }
    
    func onAppear() {
        fetchTrendingSearches {}
        fetchRecentSearches()
    }
    
    func fetchTrendingSearches(completion: @escaping (() -> ())) {
        ProductsRepository.shared.fetchTrendingSearches { [weak self] trendingSearches in
            if let trendingSearches = trendingSearches {
                self?.trendingSearchesFullList = trendingSearches
            } else {
                self?.trendingSearchesFullList = []
            }
        }
    }
    
    func fetchRecentSearches() {
        self.recentSearchesFullList = UserDefaults.standard.array(forKey: "recentSearches") as? [String] ?? []
    }
    
    func removeRecentSearches() {
        recentSearchesFullList.removeAll()
        UserDefaults.standard.set(recentSearchesFullList, forKey: "recentSearches")
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func addToRecentSearches(searchText: String) {
        if !recentSearchesFullList.contains(searchText) {
            recentSearchesFullList.append(searchText)
            UserDefaults.standard.set(recentSearchesFullList, forKey: "recentSearches")
        }
    }
}
