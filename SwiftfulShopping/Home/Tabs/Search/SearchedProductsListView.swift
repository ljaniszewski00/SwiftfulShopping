//
//  SearchedProductsListView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI

struct SearchedProductsListView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @AppStorage("productsListDisplayMethod") var displayMethod: ProductDisplayMethod = .list
    
    var body: some View {
        buildProductsListFor()
            .padding()
            .sheet(isPresented: $exploreViewModel.presentSortingAndFilteringSheet) {
                SortingAndFilteringSheetView()
                    .environmentObject(exploreViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
            }
    }
    
    @ViewBuilder
    func buildProductsListFor() -> some View {
        VStack {
            ForEach(exploreViewModel.changingProductsToBeDisplayed, id: \.self) { product in
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        searchViewModel.changeFocusedProductFor(product: product)
                    }
                } label: {
                    if displayMethod == .list {
                        ListProductCardTileView(product: product)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                            .measureSize(size: $searchViewModel.productTileSize)
                    } else {
                        GridProductCardTileView(product: product)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                            .measureSize(size: $searchViewModel.productTileSize)
                    }
                }
                .buttonStyle(ScaledButtonStyle())
            }
        }
    }
}

struct SearchedProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        let searchViewModel = SearchViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SearchedProductsListView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(searchViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
