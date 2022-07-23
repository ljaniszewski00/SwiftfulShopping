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
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(ExploreViewTabs.allCases, id: \.self) { tabName in
                                VStack {
                                    Text(tabName.rawValue)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .padding()
                                        .if(tabName == exploreViewModel.selectedTab) {
                                            $0
                                                .background {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(.accentColor)
                                                }
                                        }
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                exploreViewModel.selectedTab = tabName
                                            }
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
                        }
                    } else {
                        ProductsListView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                            .environmentObject(profileViewModel)
                    }
                    
                    NavigationLink(destination: ProductDetailsView()
                                                    .environmentObject(authStateManager)
                                                    .environmentObject(tabBarStateManager)
                                                    .environmentObject(exploreViewModel)
                                                    .environmentObject(profileViewModel)
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
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationsView()
                                                    .environmentObject(authStateManager)
                                                    .environmentObject(tabBarStateManager)
                                                    .environmentObject(profileViewModel)) { Image(systemName: "bell")
                                                    }
                }
            }
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
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ExploreView()
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
