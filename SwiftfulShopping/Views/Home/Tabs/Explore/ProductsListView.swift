//
//  TrendingTabView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI

struct ProductsListView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @AppStorage(AppStorageConstants.productsListDisplayMethod) var displayMethod: ProductDisplayMethod = .list
    
    @StateObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @State var displayedProducts: [Product]
    var navigationTitle: String
    
    init(originalProducts: [Product], displayedProducts: [Product], navigationTitle: String = "") {
        self._displayedProducts = State(initialValue: displayedProducts)
        self._sortingAndFilteringViewModel = StateObject(wrappedValue: SortingAndFilteringViewModel(originalProducts: originalProducts,
                                                                                                    modifiedProducts: displayedProducts))
        self.navigationTitle = navigationTitle
    }
    
    var body: some View {
        VStack(spacing: 15) {
            buildFilterDisplayMethodPane()
                .padding(.top)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(displayedProducts, id: \.id) { product in
                        Button {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                exploreViewModel.shouldPresentProductDetailsViewFromProductsListView = true
                                exploreViewModel.changeFocusedProductFor(product: product)
                            }
                        } label: {
                            if displayMethod == .list {
                                ListProductCardTileView(product: product,
                                                        productRatings: exploreViewModel.getRatingsFor(product: product))
                            } else {
                                GridProductCardTileView(product: product,
                                                        productRatings: exploreViewModel.getRatingsFor(product: product))
                            }
                        }
                        .buttonStyle(ScaledButtonStyle())
                    }
                }
                .padding([.horizontal, .top])
                .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
                .onChange(of: sortingAndFilteringViewModel.modifiedProducts) { newValue in
                    displayedProducts = newValue
                }
            }
            
            NavigationLink(destination: ProductDetailsView(product: exploreViewModel.choosenProduct ?? Product.demoProducts[0],
                                                           productRatings: exploreViewModel.getRatingsFor(product: exploreViewModel.choosenProduct ?? Product.demoProducts[0]))
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            },
                           isActive: $exploreViewModel.shouldPresentProductDetailsViewFromProductsListView,
                           label: { EmptyView() })
        }
        .onAppear {
            tabBarStateManager.showTabBar()
        }
        .sheet(isPresented: $exploreViewModel.presentSortingAndFilteringSheet) {
            SortingAndFilteringSheetView()
                .environmentObject(sortingAndFilteringViewModel)
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(exploreViewModel.shouldPresentAllCategoryProducts ? .large : .inline)
        .navigationBarBackButtonHidden(true)
        .if(!exploreViewModel.shouldPresentAllCategoryProducts) {
            $0
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NotificationsView()) {
                            Image(systemName: "bell")
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func buildFilterDisplayMethodPane() -> some View {
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
        .padding(.horizontal)
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsListView(originalProducts: Product.demoProducts,
                                 displayedProducts: Product.demoProducts,
                                 navigationTitle: "")
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
