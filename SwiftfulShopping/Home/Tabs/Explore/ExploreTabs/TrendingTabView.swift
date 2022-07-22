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
    
    @Binding var shouldPresentProductDetailsView: Bool
    
    @State private var currentProduct: Product?
    
    @Namespace private var animation
    
    @State private var animateView: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(Product.demoProducts, id: \.self) { product in
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        currentProduct = product
                        shouldPresentProductDetailsView = true
                    }
                } label: {
                    ProductCardTileView(product: product)
                        .matchedGeometryEffect(id: product.id, in: animation)
                        .scaleEffect(currentProduct?.id == product.id && shouldPresentProductDetailsView ? 1 : 0.93)
                }
                .buttonStyle(ScaledButtonStyle())
            }
        }
        .overlay {
            if let currentProduct = currentProduct, shouldPresentProductDetailsView {
                ProductDetailsView(product: currentProduct)
                    .scaleEffect(animateView ? 1 : 0.93)
                    .transition(.identity)
                    .onAppear {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            animateView = true
                        }
                    }
                    .ignoresSafeArea(.container, edges: .top)
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
                TrendingTabView(shouldPresentProductDetailsView: .constant(false))
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
