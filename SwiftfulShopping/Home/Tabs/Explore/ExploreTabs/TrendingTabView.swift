//
//  TrendingTabView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI

struct TrendingTabView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    private var shouldPresentProductDetailsView: Binding<Bool>
    
    @State private var currentProduct: Product?
    
    private var displayMethod: Binding<ProductDisplayMethod>
    
    init(shouldPresentProductDetailsView: Binding<Bool>, displayMethod: Binding<ProductDisplayMethod>) {
        self.shouldPresentProductDetailsView = shouldPresentProductDetailsView
        self.displayMethod = displayMethod
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if displayMethod.wrappedValue == .list {
                ForEach(Product.demoProducts, id: \.self) { product in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            if currentProduct == product {
                                currentProduct = nil
                            } else {
                                currentProduct = product
                            }
                            shouldPresentProductDetailsView.wrappedValue = true
                        }
                    } label: {
                        ListProductCardTileView(product: product)
                            .scaleEffect(currentProduct?.id == product.id && shouldPresentProductDetailsView.wrappedValue ? 1 : 0.93)
                    }
                    .buttonStyle(ScaledButtonStyle())
                }
            } else {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    ForEach(Product.demoProducts, id: \.self) { product in
                        Button {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                if currentProduct == product {
                                    currentProduct = nil
                                } else {
                                    currentProduct = product
                                }
                                shouldPresentProductDetailsView.wrappedValue = true
                            }
                        } label: {
                            GridProductCardTileView(product: product)
                                .scaleEffect(currentProduct?.id == product.id && shouldPresentProductDetailsView.wrappedValue ? 1 : 0.93)
                        }
                        .buttonStyle(ScaledButtonStyle())
                    }
                }
            }
        }
    }
}

struct TrendingTabView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                TrendingTabView(shouldPresentProductDetailsView: .constant(false), displayMethod: .constant(.list))
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
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
