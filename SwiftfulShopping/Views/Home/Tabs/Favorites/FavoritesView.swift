//
//  FavoritesView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct FavoritesView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @State private var productClicked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if favoritesViewModel.favoriteProducts.isEmpty {
                    VStack(spacing: 15) {
                        Spacer()
                        Text(TexterifyManager.localisedString(key: .favoritesView(.youHaveNotAddedAnythingYet)))
                            .font(.ssTitle2)
                        Text(getClickButtonText())
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                        Spacer()
                    }
                } else {
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
                                                                productRatings: exploreViewModel.getRatingsFor(product: product))
                                    }
                                    .buttonStyle(ScaledButtonStyle())
                                }
                            }
                            .padding(.bottom, 70)
                        }
                        
                        NavigationLink(destination: ProductDetailsView(product: favoritesViewModel.choosenProduct ?? Product.demoProducts[0],
                                                                       productRatings: exploreViewModel.getRatingsFor(product: favoritesViewModel.choosenProduct ?? Product.demoProducts[0]))
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
            }
            .padding()
            .navigationTitle(TexterifyManager.localisedString(key: .favoritesView(.navigationTitle)))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .environmentObject(tabBarStateManager)
        .environmentObject(exploreViewModel)
        .environmentObject(profileViewModel)
        .environmentObject(favoritesViewModel)
        .environmentObject(cartViewModel)
    }
    
    private func getClickButtonText() -> String {
        var clickButtonText = TexterifyManager.localisedString(key: .favoritesView(.clickLabel))
        let substring = " "
        
        let indices = getIndexesOfOcurrencesOf(substring, in: clickButtonText)
        
        clickButtonText.insert(contentsOf: " ♡", at: indices[1])
        return clickButtonText
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                FavoritesView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
//                        favoritesViewModel.favoriteProducts = Product.demoProducts
                    }
            }
        }
    }
}
