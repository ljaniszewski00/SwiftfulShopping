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
    
    @StateObject private var tabBarStateManager = TabBarStateManager()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var exploreViewModel = ExploreViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var sortingAndFilteringViewModel = SortingAndFilteringViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    
    @StateObject var firebaseAuthManager = FirebaseAuthManager.client
    @StateObject var networkManager = NetworkManager.shared
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var selection: String = TexterifyManager.localisedString(key: .homeView(.exploreTabName))
    @State private var tabSelection: TabBarItem = .explore
    
    // MARK: To add sample data to Firestore
    init() {
//        FirestoreSampleDataManager.client.addAll { _ in }
//        FirestoreSampleDataManager.client.addOrders { _ in }
//        FirestoreSampleDataManager.client.addProducts { _ in }
    }
    
    var body: some View {
        if firebaseAuthManager.isLogged {
            CustomTabBarContainerView(selection: $tabSelection,
                                      shoppingCartProductsNumber: cartViewModel.cartAllProductsQuantityCount) {
                ExploreView()
                    .environmentObject(firebaseAuthManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
                    .onAppear {
                        exploreViewModel.productsForTab = .exploreView
                    }
                    .onDisappear {
                        sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
                    }
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
                    .environmentObject(sortingAndFilteringViewModel)
                    .environmentObject(searchViewModel)
                    .onAppear {
                        exploreViewModel.productsForTab = .searchView
                    }
                    .onDisappear {
                        sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
                    }
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
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
            .modifier(LoadingIndicatorModal(isPresented: $homeViewModel.showLoadingModal))
            .onAppear {
                homeViewModel.showLoadingModal = true
                self.onAppear {
                    homeViewModel.showLoadingModal = false
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .onChange(of: networkManager.isConnected) { newValue in
                if !newValue {
                    errorManager.generateCustomError(errorType: .networkError)
                }
            }
        } else {
            ContentView()
                .transition(.slide)
        }
    }
    
    func onAppear(completion: @escaping (() -> ())) {
        profileViewModel.fetchData { result in
            switch result {
            case .success:
                exploreViewModel.fetchData {
                    cartViewModel.onAppear()
                    searchViewModel.onAppear()
                    favoritesViewModel.fetchFavorites()
                    completion()
                }
            case .failure(let error):
                profileViewModel.signOut { result in
                    switch result {
                    case .success:
                        break
                    case .failure(_):
                        errorManager.generateCustomError(errorType: .dataFetchError,
                                                         additionalErrorDescription: error.localizedDescription)
                    }
                    completion()
                }
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
