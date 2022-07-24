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
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @State private var productClicked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(favoritesViewModel.favoriteProducts, id: \.self) { product in
                        Button {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                exploreViewModel.changeFocusedProductFor(product: product, favorite: true)
                            }
                        } label: {
                            ListProductCardTileView(product: product)
                                .environmentObject(favoritesViewModel)
                                .scaleEffect((exploreViewModel.currentProduct?.id == product.id && productClicked) ? 1 : 0.93)
                        }
                        .buttonStyle(ScaledButtonStyle())
                    }
                    .navigationTitle("Favorites")
                    .navigationBarTitleDisplayMode(.inline)
                }
                
                NavigationLink(destination: ProductDetailsView()
                                                .environmentObject(authStateManager)
                                                .environmentObject(tabBarStateManager)
                                                .environmentObject(exploreViewModel)
                                                .environmentObject(profileViewModel)
                                                .environmentObject(cartViewModel)
                                                .environmentObject(favoritesViewModel)
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
        FavoritesView()
    }
}
