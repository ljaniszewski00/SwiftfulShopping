//
//  ExploreView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import SwiftUI
import Kingfisher
import texterify_ios_sdk

struct ExploreView: View {
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
                            
                            if !exploreViewModel.shouldPresentAllCategoryProducts {
                                buildNewestProductsList()
                                    .padding(.bottom)
                                
                                buildCompaniesGrid()
                                
                                buildRecommendedProductsList()
                                
                                Button {
                                    exploreViewModel.productsForSource = .all
                                    exploreViewModel.shouldPresentAllProducts = true
                                } label: {
                                    Text(TexterifyManager.localisedString(key: .exploreView(.allProductsButton)))
                                }
                                .buttonStyle(CustomButton())
                                .padding()
                            }
                            
                            NavigationLink(destination: ProductsListView(),
                                           isActive: $exploreViewModel.shouldPresentAllProducts,
                                           label: { EmptyView() })
                            
                            NavigationLink(destination: ProductDetailsView(product: exploreViewModel.choosenProduct ??
                                                                           Product.demoProducts[0],
                                                                           productRatings: exploreViewModel.getRatingsFor(product: exploreViewModel.choosenProduct ?? Product.demoProducts[0]))
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
                        }
                        .padding()
                        .padding(.bottom, 60)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        .zIndex(1)
                    }
                }
            }
            .navigationTitle(TexterifyManager.localisedString(key: .exploreView(.navigationTitle)))
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
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        }
        .navigationViewStyle(.stack)
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
            VStack(alignment: .leading, spacing: 0) {
                Text(TexterifyManager.localisedString(key: .exploreView(.categoriesLabel)))
                    .font(.ssTitle2)
                    .foregroundColor(.black)
                    .padding([.leading, .top])
                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(), alignment: .leading)
                    .padding(.bottom, 10)
                    .background {
                        Rectangle()
                            .foregroundColor(.accentColor)
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Category.allCases, id: \.self) { category in
                                Button {
                                    if exploreViewModel.choosenCategory == category &&
                                        exploreViewModel.shouldPresentAllCategoryProducts == true {
                                        exploreViewModel.choosenCategory = nil
                                        exploreViewModel.shouldPresentAllCategoryProducts = false
                                    } else {
                                        exploreViewModel.productsForSource = .category
                                        exploreViewModel.choosenCategory = category
                                        exploreViewModel.shouldPresentAllCategoryProducts = true
                                    }
                                } label: {
                                    VStack(spacing: 15) {
                                        if let categoryImageURLString = exploreViewModel.productsCategoriesWithImageURL[category], let categoryImageURLString = categoryImageURLString {
                                            KFImage(URL(string: categoryImageURLString)!)
                                                .placeholder {
                                                    Image("product_placeholder_image")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 40, height: 40)
                                                }
                                                .retry(maxCount: 3, interval: .seconds(3))
                                                .cancelOnDisappear(true)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .if(exploreViewModel.shouldPresentAllCategoryProducts) {
                                                    $0
                                                        .if(category != exploreViewModel.choosenCategory) {
                                                            $0
                                                                .opacity(0.6)
                                                        }
                                                }
                                        } else {
                                            Image("product_placeholder_image")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                        }
                                        
                                        Text(category.rawValue)
                                            .font(.ssButton)
                                            .foregroundColor(category == exploreViewModel.choosenCategory ? (colorScheme == .dark ? .ssWhite : .black) : .ssDarkGray)
                                    }
                                    .padding(.vertical)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .background(.ultraThinMaterial, in: Rectangle())
            }
            .measureSize(size: $exploreViewModel.categoriesTileSize)
            
            if exploreViewModel.shouldPresentAllCategoryProducts {
                ProductsListView()
            }
        }
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
                    ListProductCardTileView(product: product,
                                            productRatings: exploreViewModel.getRatingsFor(product: product))
                }
                .buttonStyle(ScaledButtonStyle())
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func buildNewestProductsList() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(TexterifyManager.localisedString(key: .exploreView(.newestLabel)))
                .font(.ssTitle2)
                .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                .padding([.leading, .top])
            
            prepareProductsListFor(products: exploreViewModel.newestProducts)
            
            HStack {
                Spacer()
                
                Button {
                    exploreViewModel.productsForSource = .newest
                    exploreViewModel.shouldPresentAllNewProducts = true
                } label: {
                    Text(TexterifyManager.localisedString(key: .exploreView(.seeAllNewestButton)))
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
            Text(TexterifyManager.localisedString(key: .exploreView(.companiesLabel)))
                .font(.ssTitle2)
                .foregroundColor(.black)
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
            .padding(.horizontal)
            
            NavigationLink(destination: ProductsListView(),
                           isActive: $exploreViewModel.shouldPresentAllCompanyProducts,
                           label: { EmptyView() })
        }
        .background(.ultraThinMaterial, in: Rectangle())
    }
    
    @ViewBuilder
    func buildRecommendedProductsList() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(TexterifyManager.localisedString(key: .exploreView(.recommendedLabel)))
                .font(.ssTitle2)
                .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                .padding([.leading, .top])
            
            prepareProductsListFor(products: exploreViewModel.recommendedProducts)
            
            HStack {
                Spacer()
                
                Button {
                    exploreViewModel.productsForSource = .recommended
                    exploreViewModel.shouldPresentAllRecommendedProducts = true
                } label: {
                    Text(TexterifyManager.localisedString(key: .exploreView(.seeAllRecommendedButton)))
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
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let cartViewModel = CartViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ExploreView()
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
