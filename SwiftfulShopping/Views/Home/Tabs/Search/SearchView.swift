//
//  SearchView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct SearchView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @AppStorage("productsListDisplayMethod") var displayMethod: ProductDisplayMethod = .list
    
    @State var offset: CGPoint = .zero
    
    private let gridColumns = [GridItem(.flexible(), spacing: 0),
                               GridItem(.flexible(), spacing: 0),
                               GridItem(.flexible(), spacing: 0)]
    
    var buttonUpVisible: Bool {
        if !exploreViewModel.changingProductsToBeDisplayed.isEmpty && !exploreViewModel.searchProductsText.isEmpty {
            let heightToShow = searchViewModel.productTileSize.height + searchViewModel.filterAndDisplayPaneSize.height
            return offset.y >= heightToShow
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollViewReader in
                ZStack(alignment: .bottomTrailing) {
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
                                                                    .font(.ssBody)
                                                                    .foregroundColor(.ssWhite)
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
                                    .measureSize(size: $searchViewModel.filterAndDisplayPaneSize)
                                    
                                    SearchedProductsListView()
                                }
                                
                                if !exploreViewModel.searchProductsText.isEmpty && exploreViewModel.changingProductsToBeDisplayed.isEmpty {
                                    VStack {
                                        LottieView(name: LottieAssetsNames.searchNoResults,
                                                   loopMode: .loop,
                                                   contentMode: .scaleAspectFill)
                                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                               height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.5)
                                        VStack(spacing: 20) {
                                            Text(TexterifyManager.localisedString(key: .searchView(.noProductsFound)))
                                                .font(.ssTitle2)
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text(TexterifyManager.localisedString(key: .searchView(.pleaseTryAnotherSearchKey)))
                                                .font(.ssCallout)
                                                .foregroundColor(.ssDarkGray)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                }
                            }
                        }
                        .id(0)
                        .readingScrollView(from: "scroll", into: $offset)
                        .searchable(text: $exploreViewModel.searchProductsText,
                                    prompt: TexterifyManager.localisedString(key: .searchView(.searchForProductsPrompt)))
                        .onChange(of: exploreViewModel.searchProductsText) { newValue in
                            if !newValue.isEmpty {
                                exploreViewModel.getProductsToBeDisplayedBySearch()
                            }
                        }
                        .onSubmit(of: .search) {
                            searchViewModel.addToRecentSearches(searchText: exploreViewModel.searchProductsText)
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onChange(of: searchViewModel.scrollProductsListToBeginning) { newValue in
                        if newValue {
                            withAnimation {
                                scrollViewReader.scrollTo(0, anchor: .top)
                                searchViewModel.scrollProductsListToBeginning = false
                            }
                        }
                    }
                    
                    if buttonUpVisible {
                        Button {
                            searchViewModel.scrollProductsListToBeginning = true
                        } label: {
                            Image(systemName: "arrowtriangle.up.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.ssWhite)
                                .padding()
                                .background {
                                    Circle()
                                        .foregroundColor(.accentColor)
                                        .shadow(color: .black,
                                                radius: 5,
                                                x: 3,
                                                y: 3)
                                }
                        }
                        .padding()
                        .padding(.bottom, 60)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        .zIndex(1)
                    }
                }
                
                NavigationLink(destination: ProductRecognizerView()
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                }
                                                .onDisappear {
                                                    tabBarStateManager.showTabBar()
                                                },
                               isActive: $searchViewModel.shouldPresentProductRecognizerView,
                               label: { EmptyView() })
                .isDetailLink(false)
                
                NavigationLink(destination: ProductDetailsView(product: searchViewModel.choosenProduct ?? Product.demoProducts[0],
                                                               productRatings: exploreViewModel.getRatingsFor(product: searchViewModel.choosenProduct ?? Product.demoProducts[0]))
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $searchViewModel.shouldPresentProductDetailsView,
                               label: { EmptyView() })
            }
            .modifier(LoadingIndicatorModal(isPresented: $cartViewModel.showLoadingModal))
            .navigationTitle(TexterifyManager.localisedString(key: .searchView(.navigationTitle)))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation {
                            searchViewModel.shouldPresentProductRecognizerView = true
                        }
                    } label: {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                    }
                }
            }
            .onAppear {
                tabBarStateManager.showTabBar()
            }
        }
        .navigationViewStyle(.stack)
        .environmentObject(tabBarStateManager)
        .environmentObject(exploreViewModel)
        .environmentObject(profileViewModel)
        .environmentObject(favoritesViewModel)
        .environmentObject(cartViewModel)
        .environmentObject(searchViewModel)
        .environmentObject(sortingAndFilteringViewModel)
    }
    
    @ViewBuilder
    func buildTrendingSearchesList() -> some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text(TexterifyManager.localisedString(key: .searchView(.trendingSearchesText)))
                    .font(.ssTitle3)
                Text(TexterifyManager.localisedString(key: .searchView(.newText)))
                    .font(.ssBody)
                    .padding(7)
                    .padding(.horizontal, 7)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.accentColor)
                    }
                
                Spacer()
            }
            
            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 10) {
                ForEach(searchViewModel.shouldPresentAllTrendingSearches ? searchViewModel.trendingSearchesFullList : searchViewModel.trendingSearches, id: \.self) { trendingSearch in
                    Button {
                        withAnimation {
                            exploreViewModel.searchProductsText = trendingSearch
                        }
                    } label: {
                        Text(trendingSearch)
                            .padding(12)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .ssWhite)
                    }
                    .padding(.horizontal, 5)
                }
            }
            .font(.ssCallout)
            
            if searchViewModel.trendingSearchesSeeHideAllButtonVisible {
                Button {
                    withAnimation {
                        searchViewModel.shouldPresentAllTrendingSearches.toggle()
                    }
                } label: {
                    Text(searchViewModel.shouldPresentAllTrendingSearches ? TexterifyManager.localisedString(key: .searchView(.hideAllButton)) : TexterifyManager.localisedString(key: .searchView(.seeAllButton)))
                        .font(.ssButton)
                        .foregroundColor(.accentColor)
                        .padding()
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func buildRecentSearchesList() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(TexterifyManager.localisedString(key: .searchView(.recentSearchesText)))
                    .font(.ssTitle3)
                Spacer()
                
                Button {
                    withAnimation {
                        searchViewModel.removeRecentSearches()
                        searchViewModel.shouldPresentAllRecentSearches = false
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .searchView(.clearAllButton)))
                        .font(.ssButton)
                        .foregroundColor(.accentColor)
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
                            .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .ssWhite)
                    }
                    .padding(.horizontal, 5)
                }
            }
            .font(.ssCallout)
            
            if searchViewModel.recentSearchesSeeHideAllButtonVisible  {
                Button {
                    withAnimation {
                        searchViewModel.shouldPresentAllRecentSearches.toggle()
                    }
                } label: {
                    Text(searchViewModel.shouldPresentAllRecentSearches ? TexterifyManager.localisedString(key: .searchView(.hideAllButton)) : TexterifyManager.localisedString(key: .searchView(.seeAllButton)))
                        .padding()
                        .font(.ssButton)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        let searchViewModel = SearchViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SearchView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
                    .environmentObject(searchViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
