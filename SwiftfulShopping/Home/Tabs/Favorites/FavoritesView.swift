//
//  FavoritesView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @State private var productClicked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(favoritesViewModel.favoriteProducts, id: \.self) { product in
                            Button {
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    favoritesViewModel.changeFocusedProductFor(product: product)
                                }
                            } label: {
                                ListProductCardTileView(product: product,
                                                        productAverageRating: exploreViewModel.calculateProductAverageRating(product: product),
                                                        productRatingsCount: exploreViewModel.getProductRatingsCount(product: product))
                                    .environmentObject(favoritesViewModel)
                            }
                            .buttonStyle(ScaledButtonStyle())
                        }
                    }
                    .padding(.bottom, 70)
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)
                
                NavigationLink(destination: ProductDetailsView(product: favoritesViewModel.choosenProduct ?? Product.demoProducts[0])
                                                .environmentObject(authStateManager)
                                                .environmentObject(tabBarStateManager)
                                                .environmentObject(exploreViewModel)
                                                .environmentObject(profileViewModel)
                                                .environmentObject(favoritesViewModel)
                                                .environmentObject(cartViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                }
                                                .onDisappear {
                                                    tabBarStateManager.showTabBar()
                                                },
                               isActive: $favoritesViewModel.shouldPresentProductDetailsView,
                               label: { EmptyView() })
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                FavoritesView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        
                        favoritesViewModel.favoriteProducts = Product.demoProducts
                    }
            }
        }
    }
}
