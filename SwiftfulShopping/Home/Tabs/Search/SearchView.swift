//
//  SearchView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @StateObject private var searchViewModel: SearchViewModel = SearchViewModel()
    
    @AppStorage("productsListDisplayMethod") var displayMethod: ProductDisplayMethod = .list
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private let gridColumns = [GridItem(.flexible(), spacing: 0),
                               GridItem(.flexible(), spacing: 0),
                               GridItem(.flexible(), spacing: 0)]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack(alignment: .center) {
                    if exploreViewModel.searchProductsText.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            buildTrendingSearchesList()
                            buildRecentSearchesList()
                        }
                        .onAppear {
                            sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
                        }
                    }
                    
                    VStack {
                        if !exploreViewModel.searchProductsText.isEmpty {
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
                                                            .font(.system(size: 14, weight: .regular, design: .rounded))
                                                            .foregroundColor(.white)
                                                    }
                                                    .offset(x: 17, y: -17)
                                                )
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
                            .padding([.horizontal, .top])
                        }
                        
                        if !exploreViewModel.searchProductsText.isEmpty && exploreViewModel.changingProductsToBeDisplayed.isEmpty {
                            VStack {
                                LottieView(name: "searchNoResults",
                                           loopMode: .loop,
                                           contentMode: .scaleAspectFill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.5)
                                VStack(spacing: 10) {
                                    Text("No products found!")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("Please try another search key or change filtering method.")
                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        
                        VStack {
                            SearchedProductsListView()
                                .environmentObject(authStateManager)
                                .environmentObject(tabBarStateManager)
                                .environmentObject(exploreViewModel)
                                .environmentObject(profileViewModel)
                                .environmentObject(favoritesViewModel)
                                .environmentObject(cartViewModel)
                                .environmentObject(searchViewModel)
                                .environmentObject(sortingAndFilteringViewModel)
                            
                            NavigationLink(destination: ProductDetailsView(product: searchViewModel.choosenProduct ?? Product.demoProducts[0])
                                                            .environmentObject(authStateManager)
                                                            .environmentObject(tabBarStateManager)
                                                            .environmentObject(exploreViewModel)
                                                            .environmentObject(profileViewModel)
                                                            .environmentObject(favoritesViewModel)
                                                            .environmentObject(cartViewModel)
                                                            .onAppear {
                                                                tabBarStateManager.hideTabBar()
                                                            },
                                           isActive: $searchViewModel.shouldPresentProductDetailsView,
                                           label: { EmptyView() })
                            
                            NavigationLink(destination: ProductRecognizerView()
                                                            .environmentObject(exploreViewModel)
                                                            .environmentObject(searchViewModel)
                                                            .onAppear {
                                                                tabBarStateManager.hideTabBar()
                                                            }
                                                            .onDisappear {
                                                                tabBarStateManager.showTabBar()
                                                            },
                                           isActive: $searchViewModel.shouldPresentProductRecognizerView,
                                           label: { EmptyView() })
                        }
                        .searchable(text: $exploreViewModel.searchProductsText,
                                    prompt: "Search For Products")
                        .onSubmit(of: .search) {
                            searchViewModel.addToRecentSearches(searchText: exploreViewModel.searchProductsText)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation {
                            searchViewModel.shouldPresentProductRecognizerView = true
                        }
                    } label: {
                        Image(systemName: "camera")
                    }
                }
            }
            .onAppear {
                tabBarStateManager.showTabBar()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            searchViewModel.onAppear()
        }
    }
    
    @ViewBuilder
    func buildTrendingSearchesList() -> some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text("Trending Searches")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Text("New")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .padding(7)
                    .padding(.horizontal, 7)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.accentColor)
                    }
                
                Spacer()
            }
            
            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 10) {
                ForEach(searchViewModel.shouldPresentAllTrendingSearches ? searchViewModel.trendingSearchesFullList : searchViewModel.trendingSearches, id: \.self) { recentSearch in
                    Button {
                        withAnimation {
                            exploreViewModel.searchProductsText = recentSearch
                        }
                    } label: {
                        Text(recentSearch)
                            .padding(12)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .white)
                    }
                }
            }
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            Button {
                withAnimation {
                    searchViewModel.shouldPresentAllTrendingSearches.toggle()
                }
            } label: {
                Text(searchViewModel.shouldPresentAllTrendingSearches ? "Hide all" : "See all")
                    .padding()
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func buildRecentSearchesList() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recent Searches")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Spacer()
                
                Button {
                    withAnimation {
                        searchViewModel.removeRecentSearches()
                        searchViewModel.shouldPresentAllRecentSearches = false
                    }
                } label: {
                    Text("Clear all")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                        .padding(12)
                }
            }
            
            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 10) {
                ForEach(searchViewModel.shouldPresentAllRecentSearches ? searchViewModel.recentSearchesFullList : searchViewModel.recentSearches, id: \.self) { recentSearch in
                    Button {
                        withAnimation {
                            exploreViewModel.searchProductsText = recentSearch
                        }
                    } label: {
                        Text(recentSearch)
                            .padding(12)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .white)
                    }
                }
            }
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            if !searchViewModel.recentSearchesFullList.isEmpty {
                Button {
                    withAnimation {
                        searchViewModel.shouldPresentAllRecentSearches.toggle()
                    }
                } label: {
                    Text(searchViewModel.shouldPresentAllRecentSearches ? "Hide all" : "See all")
                        .padding()
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
            }
        }
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
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
                SearchView()
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
            }
        }
    }
}
