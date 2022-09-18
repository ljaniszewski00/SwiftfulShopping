//
//  TrendingTabView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI

struct ProductsListView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @AppStorage("productsListDisplayMethod") var displayMethod: ProductDisplayMethod = .list
    
    private var navigationTitle: String {
        switch exploreViewModel.productsForSource {
        case .category:
            return exploreViewModel.choosenCategory?.rawValue ?? ""
        case .company:
            return exploreViewModel.choosenCompany ?? ""
        default:
            return exploreViewModel.productsForSource.rawValue
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            buildFilterDisplayMethodPane()
            
            ScrollView(.vertical) {
                ForEach(exploreViewModel.changingProductsToBeDisplayed, id: \.id) { product in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            exploreViewModel.changeFocusedProductFor(product: product)
                        }
                    } label: {
                        if displayMethod == .list {
                            ListProductCardTileView(product: product)
                        } else {
                            GridProductCardTileView(product: product)
                        }
                    }
                    .buttonStyle(ScaledButtonStyle())
                }
            }
        }
        .padding()
        .sheet(isPresented: $exploreViewModel.presentSortingAndFilteringSheet) {
            SortingAndFilteringSheetView()
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
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
        let exploreViewModel = ExploreViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsListView()
                    .environmentObject(exploreViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
