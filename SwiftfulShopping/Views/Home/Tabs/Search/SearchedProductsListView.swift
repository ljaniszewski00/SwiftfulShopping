//
//  SearchedProductsListView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI

struct SearchedProductsListView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @AppStorage(AppStorageConstants.productsListDisplayMethod) var displayMethod: ProductDisplayMethod = .list
    
    @State var displayedProducts: [Product]
    
    init(displayedProducts: [Product]) {
        self._displayedProducts = State(initialValue: displayedProducts)
    }
    
    var body: some View {
        buildProductsListFor()
            .padding()
            .sheet(isPresented: $exploreViewModel.presentSortingAndFilteringSheet) {
                SortingAndFilteringSheetView()
            }
    }
    
    @ViewBuilder
    func buildProductsListFor() -> some View {
        VStack {
            ForEach(displayedProducts, id: \.self) { product in
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        searchViewModel.changeFocusedProductFor(product: product)
                    }
                } label: {
                    if displayMethod == .list {
                        ListProductCardTileView(product: product,
                                                productRatings: exploreViewModel.getRatingsFor(product: product))
                            .measureSize(size: $searchViewModel.productTileSize)
                    } else {
                        GridProductCardTileView(product: product,
                                                productRatings: exploreViewModel.getRatingsFor(product: product))
                            .measureSize(size: $searchViewModel.productTileSize)
                    }
                }
                .buttonStyle(ScaledButtonStyle())
                .onChange(of: sortingAndFilteringViewModel.modifiedProducts) { newValue in
                    displayedProducts = newValue
                }
            }
        }
    }
}

struct SearchedProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        let searchViewModel = SearchViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel(originalProducts: Product.demoProducts,
                                                                        modifiedProducts: Product.demoProducts)
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SearchedProductsListView(displayedProducts: Product.demoProducts)
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
            }
        }
    }
}
