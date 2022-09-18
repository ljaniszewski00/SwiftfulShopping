//
//  HomeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var accentColorManager: AccentColorManager
    
    @StateObject private var tabBarStateManager = TabBarStateManager()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var exploreViewModel = ExploreViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var sortingAndFilteringViewModel = SortingAndFilteringViewModel()
    
    @StateObject var networkManager = NetworkManager.shared
    @StateObject var errorManager = ErrorManager.shared
    
    @State var selectedTab: Tab = .explore
        
    enum Tab: String {
        case explore
        case favorites
        case cart
        case search
        case profile
    }
    
    struct TabItem: Identifiable {
        var id = UUID()
        var text: String = ""
        var icon: String
        var tab: Tab
    }
    
    private var tabItems = [
        TabItem(text: "Explore", icon: "house", tab: .explore),
        TabItem(text: "Favorites", icon: "star", tab: .favorites),
        TabItem(text: "Cart", icon: "cart", tab: .cart),
        TabItem(text: "Search", icon: "magnifyingglass", tab: .search),
        TabItem(text: "Profile", icon: "person", tab: .profile)
    ]
    
    var body: some View {
        if authStateManager.isLogged || authStateManager.isGuest {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .explore:
                        ExploreView()
                            .environmentObject(authStateManager)
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
                    case .favorites:
                        FavoritesView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(cartViewModel)
                            .environmentObject(favoritesViewModel)
                    case .cart:
                        CartView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                    case .search:
                        SearchView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                            .environmentObject(sortingAndFilteringViewModel)
                            .onAppear {
                                exploreViewModel.productsForTab = .searchView
                            }
                            .onDisappear {
                                sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
                            }
                    case .profile:
                        ProfileView()
                            .environmentObject(authStateManager)
                            .environmentObject(accentColorManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(profileViewModel)
                    }
                }
                
                if !tabBarStateManager.isHidden {
                    HStack {
                        Spacer()
                        
                        ForEach(tabItems) { tabItem in
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTab = tabItem.tab
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: tabItem.icon)
                                        .resizable()
                                        .symbolVariant(.fill)
                                        .font(.body.bold())
                                        .frame(width: 25, height: 25)
                                    Text(tabItem.text)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedTab == tabItem.tab ? .accentColor : Color(uiColor: .systemGray))
                                .if(tabItem.tab == .cart && cartViewModel.cartProductsCount > 0) {
                                    $0
                                        .overlay(
                                            ZStack {
                                                Circle()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.red)
                                                Text(String(cartViewModel.cartProductsCount))
                                                    .font(.ssCallout)
                                                    .foregroundColor(.ssWhite)
                                            }
                                            .offset(x: 22, y: -27)
                                        )
                                }
                            }
                            .foregroundStyle(selectedTab == tabItem.tab ? .primary : .secondary)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 7)
                    .padding(.bottom, 10)
                    .frame(height: 100, alignment: .center)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40, style: .continuous))
                    .measureSize(size: $tabBarStateManager.tabBarSize)
                    .navigationBarTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .transition(.move(edge: .bottom))
                    .animation(.default)
                    .zIndex(1)
                }
            }
            .modifier(LoadingIndicatorModal(isPresented: $homeViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
            .onAppear {
                exploreViewModel.fetchProducts()
                cartViewModel.restorePreviousCart()
                favoritesViewModel.fetchFavorites()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let accentColorManager = AccentColorManager()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                HomeView()
                    .environmentObject(authStateManager)
                    .environmentObject(accentColorManager)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
