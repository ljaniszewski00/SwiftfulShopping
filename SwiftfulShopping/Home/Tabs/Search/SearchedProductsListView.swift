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
        VStack(spacing: 10) {
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        exploreViewModel.presentSortingAndFilteringSheet = true
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
                .isHidden(exploreViewModel.productsToBeDisplayedBySearch.isEmpty)
                
                Spacer()
                
                Button {
                    withAnimation {
                        displayMethod = .grid
                    }
                } label: {
                    Image(systemName: "rectangle.grid.3x2")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
                .isHidden(exploreViewModel.productsToBeDisplayedBySearch.isEmpty)
                
                Button {
                    withAnimation {
                        displayMethod = .list
                    }
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
                .isHidden(exploreViewModel.productsToBeDisplayedBySearch.isEmpty)
            }
            .padding(.horizontal)
            
            buildProductsListFor()
        }
        .padding()
        .sheet(isPresented: $exploreViewModel.presentSortingAndFilteringSheet) {
            SortingAndFilteringSheetView()
                .environmentObject(exploreViewModel)
                .environmentObject(sortingAndFilteringViewModel)
        }
    }
    
    @ViewBuilder
    func buildProductsListFor() -> some View {
        ForEach(exploreViewModel.productsToBeDisplayedBySearch, id: \.self) { product in
            Button {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    searchViewModel.changeFocusedProductFor(product: product)
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
