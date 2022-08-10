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
    
    var listProductsAfterSearch: Bool = false
    
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
                
                if (exploreViewModel.selectedTab == .categories && exploreViewModel.displayedCategory != nil) {
                    HStack {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.accentColor)
                        Text(exploreViewModel.displayedCategory!.rawValue)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
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
            
            if exploreViewModel.displayMethod == .list {
                buildProductsListFor(displayMethod: .list)
            } else {
                buildProductsListFor(displayMethod: .grid)
            }
        }
        .padding()
        .sheet(isPresented: $exploreViewModel.presentSortingAndFilteringSheet) {
            SortingAndFilteringSheetView()
                .environmentObject(exploreViewModel)
        }
    }
    
    @ViewBuilder
    func buildProductsListFor(displayMethod: ProductDisplayMethod) -> some View {
        ForEach(exploreViewModel.productsToBeDisplayed, id: \.self) { product in
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

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsListView()
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
                    }
            }
        }
    }
}
