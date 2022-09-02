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
    
    @AppStorage("productsListDisplayMethod") var displayMethod: ProductDisplayMethod = .list
    
    @State var offset: CGPoint = .zero
    
    var buttonUpVisible: Bool {
        if exploreViewModel.changingProductsToBeDisplayed.isEmpty {
            return false
        } else {
            let heightToShow = exploreViewModel.productTileSize.height + exploreViewModel.tabsSize.height
            return offset.y >= heightToShow
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollViewReader in
                ZStack(alignment: .bottomTrailing) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .center) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(ExploreViewTabs.allCases, id: \.self) { tabName in
                                        Text(tabName.rawValue)
                                            .font(.ssButton)
                                            .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
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
                                .measureSize(size: $exploreViewModel.tabsSize)
                            }
                            
                            if exploreViewModel.selectedTab != .categories {
                                HStack(spacing: 20) {
                                    Button {
                                        withAnimation {
                                            exploreViewModel.presentSortingAndFilteringSheet = true
                                        }
                                    } label: {
                                        Image(systemName: "slider.horizontal.3")
                                            .resizable()
                                            .frame(width: 25, height: 20)
                                            .if(sortingAndFilteringViewModel.numberOfFiltersApplied > 0) {
                                                $0
                                                    .overlay(
                                                        ZStack {
                                                            Circle()
                                                                .frame(width: 17, height: 17)
                                                                .foregroundColor(.red)
                                                            Text(String(sortingAndFilteringViewModel.numberOfFiltersApplied))
                                                                .font(.ssBody)
                                                                .foregroundColor(.ssWhite)
                                                        }
                                                        .offset(x: 17, y: -17)
                                                    )
                                            }
                                    }
                                    
                                    if (exploreViewModel.selectedTab == .categories && exploreViewModel.displayedCategory != nil) {
                                        HStack {
                                            Image(systemName: "multiply.circle.fill")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.accentColor)
                                            Text(exploreViewModel.displayedCategory?.rawValue ?? "")
                                                .font(.ssCallout)
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
                                            displayMethod = .grid
                                        }
                                    } label: {
                                        Image(systemName: "rectangle.grid.3x2")
                                            .resizable()
                                            .frame(width: 25, height: 20)
                                    }
                                    
                                    Button {
                                        withAnimation {
                                            displayMethod = .list
                                        }
                                    } label: {
                                        Image(systemName: "list.bullet")
                                            .resizable()
                                            .frame(width: 25, height: 20)
                                    }
                                }
                                .padding(.horizontal)
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
                        .id(0)
                        .readingScrollView(from: "scroll", into: $offset)
                        .padding(.bottom, 70)
                    }
                    .coordinateSpace(name: "scroll")
                    .onChange(of: exploreViewModel.scrollProductsListToBeginning) { newValue in
                        if newValue {
                            withAnimation {
                                scrollViewReader.scrollTo(0, anchor: .top)
                                exploreViewModel.scrollProductsListToBeginning = false
                            }
                        }
                    }
                    
                    if buttonUpVisible && exploreViewModel.selectedTab != .categories {
                        Button {
                            exploreViewModel.scrollProductsListToBeginning = true
                        } label: {
                            Image(systemName: "arrow.up")
                                .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                                .padding()
                                .background {
                                    Circle()
                                        .foregroundColor(.accentColor)
                                }
                                .transition(.move(edge: .trailing))
                                .animation(.default.speed(0.5))
                                .zIndex(1)
                        }
                        .padding()
                        .padding(.bottom, 60)
                    }
                }
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
