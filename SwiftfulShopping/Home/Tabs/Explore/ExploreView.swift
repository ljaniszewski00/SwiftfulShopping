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
    
    @State var offset: CGPoint = .zero
    
    var buttonUpVisible: Bool {
        if exploreViewModel.changingProductsToBeDisplayed.isEmpty {
            return false
        } else {
            return offset.y >= exploreViewModel.categoriesTileSize.height
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollViewReader in
                ZStack(alignment: .bottomTrailing) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .center) {
                            buildCategoriesList()
                            
                            buildNewestProductsList()
                                .padding(.bottom)
                            
                            buildCompaniesGrid()
                            
                            buildRecommendedProductsList()
                            
                            Button {
                                exploreViewModel.productsForSource = .all
                                exploreViewModel.shouldPresentAllProducts = true
                            } label: {
                                Text("All Products")
                            }
                            .buttonStyle(CustomButton())
                            .padding()
                            
                            NavigationLink(destination: ProductsListView(),
                                           isActive: $exploreViewModel.shouldPresentAllProducts,
                                           label: { EmptyView() })
                            
                            NavigationLink(destination: ProductDetailsView(product: exploreViewModel.choosenProduct ?? Product.demoProducts[0])
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
                    
                    if buttonUpVisible {
                        Button {
                            exploreViewModel.scrollProductsListToBeginning = true
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
                                .transition(.move(edge: .trailing))
                                .animation(.default.speed(0.5))
                        }
                        .padding()
                        .padding(.bottom, 60)
                        .zIndex(1)
                    }
                }
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("SwiftfulShopping")
                        .font(.ssTitle3).fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationsView()) {
                        Image(systemName: "bell")
                    }
                }
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                                $exploreViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        }
        .navigationViewStyle(.stack)
        .environmentObject(authStateManager)
        .environmentObject(tabBarStateManager)
        .environmentObject(exploreViewModel)
        .environmentObject(profileViewModel)
        .environmentObject(favoritesViewModel)
        .environmentObject(cartViewModel)
        .environmentObject(sortingAndFilteringViewModel)
    }
    
    @ViewBuilder
    func buildCategoriesList() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Categories")
                .font(.ssTitle2)
                .foregroundColor(.ssBlack)
                .padding([.leading, .top])
                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(), alignment: .leading)
                .padding(.bottom, 10)
                .background {
                    Rectangle()
                        .foregroundColor(.accentColor)
                }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Category.allCases, id: \.self) { category in
                        Button {
                            exploreViewModel.productsForSource = .category
                            exploreViewModel.choosenCategory = category
                            exploreViewModel.shouldPresentAllCategoryProducts = true
                        } label: {
                            VStack(spacing: 15) {
                                Image(systemName: "cart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.ssDarkGray)
                                Text(category.rawValue)
                                    .font(.ssButton)
                                    .foregroundColor(.ssDarkGray)
                            }
                        }
                        .padding()
                    }
                }
            }
            
            NavigationLink(destination: ProductsListView(),
                           isActive: $exploreViewModel.shouldPresentAllCategoryProducts,
                           label: { EmptyView() })
        }
        .background(.ultraThinMaterial, in: Rectangle())
        .measureSize(size: $exploreViewModel.categoriesTileSize)
    }
    
    @ViewBuilder
    func prepareProductsListFor(products: [Product]) -> some View {
        VStack {
            ForEach(products, id: \.id) { product in
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        exploreViewModel.changeFocusedProductFor(product: product)
                    }
                } label: {
                    ListProductCardTileView(product: product)
                }
                .buttonStyle(ScaledButtonStyle())
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func buildNewestProductsList() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Newest")
                .font(.ssTitle2)
                .foregroundColor(.ssBlack)
                .padding([.leading, .top])
            
            prepareProductsListFor(products: exploreViewModel.newestProducts)
            
            HStack {
                Spacer()
                
                Button {
                    exploreViewModel.productsForSource = .newest
                    exploreViewModel.shouldPresentAllNewProducts = true
                } label: {
                    Text("See all newest")
                        .font(.ssButton)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.trailing)
            
            NavigationLink(destination: ProductsListView(),
                           isActive: $exploreViewModel.shouldPresentAllNewProducts,
                           label: { EmptyView() })
        }
    }
    
    @ViewBuilder
    func buildCompaniesGrid() -> some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Companies")
                .font(.ssTitle2)
                .foregroundColor(.ssBlack)
                .padding([.leading, .top])
                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(), alignment: .leading)
                .padding(.bottom, 10)
                .background {
                    Rectangle()
                        .foregroundColor(.accentColor)
                }
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80), alignment: .top)
            ], spacing: 20) {
                ForEach(exploreViewModel.productsCompanies, id: \.self) { company in
                    Button {
                        exploreViewModel.productsForSource = .company
                        exploreViewModel.choosenCompany = company
                        exploreViewModel.shouldPresentAllCompanyProducts = true
                    } label: {
                        VStack(spacing: 15) {
                            Image(systemName: "building.2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.ssDarkGray)
                            Text(company)
                                .font(.ssButton)
                                .foregroundColor(.ssDarkGray)
                        }
                    }
                    
                }
            }
            
            NavigationLink(destination: ProductsListView(),
                           isActive: $exploreViewModel.shouldPresentAllCompanyProducts,
                           label: { EmptyView() })
        }
        .background(.ultraThinMaterial, in: Rectangle())
    }
    
    @ViewBuilder
    func buildRecommendedProductsList() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recommended")
                .font(.ssTitle2)
                .foregroundColor(.ssBlack)
                .padding([.leading, .top])
            
            prepareProductsListFor(products: exploreViewModel.recommendedProducts)
            
            HStack {
                Spacer()
                
                Button {
                    exploreViewModel.productsForSource = .recommended
                    exploreViewModel.shouldPresentAllRecommendedProducts = true
                } label: {
                    Text("See all recommended")
                        .font(.ssButton)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.trailing)
            
            NavigationLink(destination: ProductsListView(),
                           isActive: $exploreViewModel.shouldPresentAllRecommendedProducts,
                           label: { EmptyView() })
        }
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
                        exploreViewModel.fetchProducts()
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
