//
//  ExploreView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @StateObject var errorManager = ErrorManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(ExploreViewTabs.allCases, id: \.self) { tabName in
                                Text(tabName.rawValue)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .padding()
                                    .if(tabName == exploreViewModel.selectedTab) {
                                        $0
                                            .background {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.accentColor)
                                            }
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            exploreViewModel.selectedTab = tabName
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    if exploreViewModel.selectedTab == .categories {
                        if exploreViewModel.displayedCategory == nil {
                            CategoriesTabView()
                                .environmentObject(authStateManager)
                                .environmentObject(tabBarStateManager)
                                .environmentObject(exploreViewModel)
                                .environmentObject(profileViewModel)
                        } else {
                            ProductsListView()
                                .environmentObject(authStateManager)
                                .environmentObject(tabBarStateManager)
                                .environmentObject(exploreViewModel)
                                .environmentObject(profileViewModel)
                                .environmentObject(favoritesViewModel)
                                .environmentObject(cartViewModel)
                                .environmentObject(sortingAndFilteringViewModel)
                        }
                    } else {
                        ProductsListView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(cartViewModel)
                            .environmentObject(sortingAndFilteringViewModel)
                    }
                    
                    NavigationLink(destination: ProductDetailsView(product: exploreViewModel.choosenProduct ?? Product.demoProducts[0])
                                                    .environmentObject(authStateManager)
                                                    .environmentObject(tabBarStateManager)
                                                    .environmentObject(exploreViewModel)
                                                    .environmentObject(profileViewModel)
                                                    .environmentObject(favoritesViewModel)
                                                    .environmentObject(cartViewModel)
                                                    .onAppear {
                                                        tabBarStateManager.hideTabBar()
                                                    }
                                                    .onDisappear {
                                                        tabBarStateManager.showTabBar()
                                                    },
                                   isActive: $exploreViewModel.shouldPresentProductDetailsView,
                                   label: { EmptyView() })
                }
                .padding(.bottom, 70)
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationsView()
                                                    .environmentObject(authStateManager)
                                                    .environmentObject(tabBarStateManager)
                                                    .environmentObject(profileViewModel)
                    ) { Image(systemName: "bell") }
                }
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                                $exploreViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        }
        .navigationViewStyle(.stack)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ExploreView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
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
