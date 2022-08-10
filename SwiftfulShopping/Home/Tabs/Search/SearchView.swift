//
//  SearchView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @StateObject private var searchViewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack(alignment: .center) {
                    if exploreViewModel.searchProductsText.isEmpty {
                        LottieView(name: "search",
                                   loopMode: .loop,
                                   contentMode: .scaleAspectFill)
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                               height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.5)
                        .offset(y: 100)
                    }
                    
                    if !exploreViewModel.searchProductsText.isEmpty && exploreViewModel.productsToBeDisplayedBySearch.isEmpty {
                        VStack {
                            LottieView(name: "searchNoResults",
                                       loopMode: .loop,
                                       contentMode: .scaleAspectFill)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.5)
                            VStack(spacing: 10) {
                                Text("No products found!")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("Please try another search key.")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .offset(y: 100)
                    }
                    
                    VStack {
                        SearchedProductsListView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                            .environmentObject(searchViewModel)
                        
                        NavigationLink(destination: ProductDetailsView(product: searchViewModel.choosenProduct ?? Product.demoProducts[0])
                                                        .environmentObject(authStateManager)
                                                        .environmentObject(tabBarStateManager)
                                                        .environmentObject(exploreViewModel)
                                                        .environmentObject(profileViewModel)
                                                        .environmentObject(favoritesViewModel)
                                                        .environmentObject(cartViewModel)
                                                        .onAppear {
                                                            tabBarStateManager.hideTabBar()
                                                        },
                                       isActive: $searchViewModel.shouldPresentProductDetailsView,
                                       label: { EmptyView() })
                    }
                    .searchable(text: $exploreViewModel.searchProductsText,
                                prompt: "Search For Products")
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                tabBarStateManager.showTabBar()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SearchView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
