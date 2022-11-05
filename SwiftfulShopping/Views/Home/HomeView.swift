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
    
    @StateObject var firebaseAuthManager = FirebaseAuthManager.client
    @StateObject var networkManager = NetworkManager.shared
    @StateObject var errorManager = ErrorManager.shared
    
    @State var selectedTab: Tab = .explore
    
//    // MARK: To add sample data to Firestore
//    init() {
//        FirestoreSampleDataManager.client.addAll { _ in }
//    }
        
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
        TabItem(text: TexterifyManager.localisedString(key: .homeView(.exploreTabName)), icon: "house", tab: .explore),
        TabItem(text: TexterifyManager.localisedString(key: .homeView(.favoritesTabName)), icon: "star", tab: .favorites),
        TabItem(text: TexterifyManager.localisedString(key: .homeView(.cartTabName)), icon: "cart", tab: .cart),
        TabItem(text: TexterifyManager.localisedString(key: .homeView(.searchTabName)), icon: "magnifyingglass", tab: .search),
        TabItem(text: TexterifyManager.localisedString(key: .homeView(.profileTabName)), icon: "person", tab: .profile)
    ]
    
    var body: some View {
        if firebaseAuthManager.isLogged {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .explore:
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
                    case .favorites:
                        FavoritesView()
                            .environmentObject(firebaseAuthManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(cartViewModel)
                            .environmentObject(favoritesViewModel)
                    case .cart:
                        CartView()
                            .environmentObject(firebaseAuthManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                    case .search:
                        SearchView()
                            .environmentObject(firebaseAuthManager)
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
                            .environmentObject(firebaseAuthManager)
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
                                .if(tabItem.tab == .cart && cartViewModel.cartAllProductsQuantityCount > 0) {
                                    $0
                                        .overlay(
                                            Text(String(cartViewModel.cartAllProductsQuantityCount))
                                                .font(.ssCallout)
                                                .foregroundColor(.ssWhite)
                                                .padding(.all, cartViewModel.cartAllProductsQuantityCount >= 10 ? 3 : 6)
                                                .background {
                                                    Circle()
                                                        .foregroundColor(.red)
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
                    favoritesViewModel.fetchFavorites()
                    completion()
                }
            case .failure(let error):
                errorManager.generateCustomError(errorType: .dataFetchError,
                                                 additionalErrorDescription: error.localizedDescription)
                completion()
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
