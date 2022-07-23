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
    
    private var shouldPresentProductDetailsView: Binding<Bool>
    
    init(shouldPresentProductDetailsView: Binding<Bool>) {
        self.shouldPresentProductDetailsView = shouldPresentProductDetailsView
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if (exploreViewModel.selectedTab == .categories && exploreViewModel.displayedCategory != nil) {
                    HStack {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.accentColor)
                        Text(exploreViewModel.displayedCategory!.rawValue)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .onTapGesture {
                        withAnimation {
                            exploreViewModel.displayedCategory = nil
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        exploreViewModel.changeDisplayMethodFor(displayMethod: .grid)
                    }
                } label: {
                    Image(systemName: "rectangle.grid.3x2")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
                
                Button {
                    withAnimation {
                        exploreViewModel.changeDisplayMethodFor(displayMethod: .list)
                    }
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                if exploreViewModel.displayMethod == .list {
                    buildProductsListFor(displayMethod: .list)
                } else {
                    buildProductsListFor(displayMethod: .grid)
                }
            }
        }
    }
    
    @ViewBuilder
    func buildProductsListFor(displayMethod: ProductDisplayMethod) -> some View {
        ForEach(exploreViewModel.productsToBeDisplayed, id: \.self) { product in
            Button {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    exploreViewModel.manageFocusedProduct(product: product)
                    shouldPresentProductDetailsView.wrappedValue = true
                }
            } label: {
                if displayMethod == .list {
                    ListProductCardTileView(product: product)
                        .scaleEffect(exploreViewModel.currentProduct?.id == product.id && shouldPresentProductDetailsView.wrappedValue ? 1 : 0.93)
                } else {
                    GridProductCardTileView(product: product)
                        .scaleEffect(exploreViewModel.currentProduct?.id == product.id && shouldPresentProductDetailsView.wrappedValue ? 1 : 0.93)
                }
            }
            .buttonStyle(ScaledButtonStyle())
        }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsListView(shouldPresentProductDetailsView: .constant(false))
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
