//
//  TrendingTabView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI

struct ProductsListView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @AppStorage("productsListDisplayMethod") var displayMethod: ProductDisplayMethod = .list
    
    var listProductsAfterSearch: Bool = false
    
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
            ForEach(exploreViewModel.changingProductsToBeDisplayed, id: \.id) { product in
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        exploreViewModel.changeFocusedProductFor(product: product)
                    }
                } label: {
                    if displayMethod == .list {
                        ListProductCardTileView(product: product)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                    } else {
                        GridProductCardTileView(product: product)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                    }
                }
                .buttonStyle(ScaledButtonStyle())
            }
        }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsListView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
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
