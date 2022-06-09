//
//  HomeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @StateObject private var tabBarStateManager = TabBarStateManager()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var exploreViewModel = ExploreViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
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
            Group {
                switch selectedTab {
                case .explore:
                    withAnimation(.linear) {
                        ExploreView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(exploreViewModel)
                    }
                case .favorites:
                    withAnimation(.linear) {
                        EmptyView()
                    }
                case .cart:
                    withAnimation(.linear) {
                        EmptyView()
                    }
                case .search:
                    withAnimation(.linear) {
                        EmptyView()
                    }
                case .profile:
                    withAnimation(.linear) {
                        ProfileView()
                            .environmentObject(authStateManager)
                            .environmentObject(tabBarStateManager)
                            .environmentObject(profileViewModel)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
                        .foregroundColor(tabItem.tab == .cart ? .white : (selectedTab == tabItem.tab ? .accentColor : Color(uiColor: .systemGray)))
                        .if(tabItem.tab == .cart) {
                            $0
                                .padding(.horizontal, 35)
                                .background(
                                    Circle()
                                        .foregroundColor(.accentColor)
                                        .frame(width: 90, height: 90)
                                        .shadow(radius: 10, x: 0, y: 15)
                                        .if(homeViewModel.thingsInCart > 0) {
                                            $0
                                                .overlay(
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 30, height: 30)
                                                            .foregroundColor(.red)
                                                        Text(String(homeViewModel.thingsInCart))
                                                            .foregroundColor(.white)
                                                    }
                                                        .offset(x: 35, y: 30)
                                                )
                                        }
                                )
                                .offset(y: -15)
                        }
                    }
                    .foregroundStyle(selectedTab == tabItem.tab ? .primary : .secondary)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .isHidden(tabBarStateManager.isHidden)
            .padding(.horizontal, 7)
            .padding(.top, 10)
            .frame(height: 100, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40, style: .continuous))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    /// Here will be notifications
                    Button(action: {
                        withAnimation {
                            authStateManager.logoutCompletely()
                        }
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            
                        }
                    }, label: {
                        Image(systemName: "bell")
                    })
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
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
                    ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                        HomeView().environmentObject(authStateManager)
                            .preferredColorScheme(colorScheme)
                            .previewDevice(PreviewDevice(rawValue: deviceName))
                            .previewDisplayName("\(deviceName) portrait")
                    }
                }
    }
}
