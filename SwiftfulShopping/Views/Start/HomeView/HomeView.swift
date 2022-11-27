//
//  HomeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import texterify_ios_sdk

struct HomeView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    @StateObject private var tabBarStateManager = TabBarStateManager()
    @StateObject private var homeViewModel = HomeViewModel()
    
    @StateObject var firebaseAuthManager = FirebaseAuthManager.client
    @StateObject var networkManager = NetworkManager.shared
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var selection: String = TexterifyManager.localisedString(key: .homeView(.exploreTabName))
    @State private var tabSelection: TabBarItem = .explore
    
    // MARK: To add sample data to Firestore
    init() {
//        FirestoreSampleDataManager.addAll { _ in }
//        FirestoreSampleDataManager.addOrders { _ in }
//        FirestoreSampleDataManager.addProducts { _ in }
//        FirestoreSampleDataManager.addRatings { _ in }
    }
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection,
                                  shoppingCartProductsNumber: cartViewModel.cartAllProductsQuantityCount) {
            ExploreView()
                .environmentObject(firebaseAuthManager)
                .environmentObject(tabBarStateManager)
                .environmentObject(exploreViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(favoritesViewModel)
                .tabBarItem(tab: .explore,
                            selection: $tabSelection)
            
            FavoritesView()
                .environmentObject(firebaseAuthManager)
                .environmentObject(tabBarStateManager)
                .environmentObject(exploreViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(favoritesViewModel)
                .tabBarItem(tab: .favorites,
                            selection: $tabSelection)
            
            CartView()
                .environmentObject(firebaseAuthManager)
                .environmentObject(tabBarStateManager)
                .environmentObject(exploreViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(cartViewModel)
                .tabBarItem(tab: .cart,
                            selection: $tabSelection)
            
            SearchView()
                .environmentObject(firebaseAuthManager)
                .environmentObject(tabBarStateManager)
                .environmentObject(exploreViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(searchViewModel)
                .tabBarItem(tab: .search,
                            selection: $tabSelection)
            
            ProfileView()
                .environmentObject(firebaseAuthManager)
                .environmentObject(accentColorManager)
                .environmentObject(tabBarStateManager)
                .environmentObject(profileViewModel)
                .tabBarItem(tab: .profile,
                            selection: $tabSelection)
        }
        .environmentObject(tabBarStateManager)
        .environmentObject(exploreViewModel)
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                             customError: errorManager.customError ?? ErrorManager.unknownError))
        .modifier(LoadingIndicatorModal(isPresented: $homeViewModel.showLoadingModal))
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: networkManager.isConnected) { isConnected in
            if !isConnected {
                errorManager.generateCustomError(errorType: .networkError)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let accentColorManager = AccentColorManager()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                HomeView()
                    .environmentObject(accentColorManager)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
