//
//  SortingAndFilteringSheetView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI

struct SortingAndFilteringSheetView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var sortingAndFilteringViewModel: SortingAndFilteringViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State private var isLowestPriceTextFieldFocused: Bool = false
    @State private var isHighestPriceTextFieldFocused: Bool = false
    
    private let filtersGridColumns = [GridItem(.flexible(), spacing: 0),
                                      GridItem(.flexible(), spacing: 0),
                                      GridItem(.flexible(), spacing: 0)]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Sorting")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Spacer()
                            Button {
                                withAnimation {
                                    sortingAndFilteringViewModel.sortingSectionHidden.toggle()
                                }
                            } label: {
                                Image(systemName: sortingAndFilteringViewModel.sortingSectionHidden ? "chevron.down" : "chevron.up")
                            }
                        }
                        
                        if !sortingAndFilteringViewModel.sortingSectionHidden {
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(SortingMethods.allCases, id: \.self) { sortingMethod in
                                    Button {
                                        withAnimation {
                                            sortingAndFilteringViewModel.sortingMethod = sortingMethod
                                        }
                                    } label: {
                                        HStack {
                                            if sortingAndFilteringViewModel.sortingMethod == sortingMethod {
                                                Image(systemName: "checkmark")
                                            }
                                            Text(sortingMethod.rawValue)
                                                .foregroundColor(colorScheme == .light ? .black : .white)
                                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Filter By")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Spacer()
                            Button {
                                withAnimation {
                                    sortingAndFilteringViewModel.filteringSectionHidden.toggle()
                                }
                            } label: {
                                Image(systemName: sortingAndFilteringViewModel.filteringSectionHidden ? "chevron.down" : "chevron.up")
                            }
                        }
                        
                        if !sortingAndFilteringViewModel.filteringSectionHidden {
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 30) {
                                ForEach(FilteringMethods.allCases, id: \.self) { filteringMethod in
                                    switch filteringMethod {
                                    case .company:
                                        buildCompanyFilteringSection()
                                    case .category:
                                        buildCategoryFilteringSection()
                                    case .price:
                                        buildPriceFilteringSection()
                                    case .rating:
                                        buildRatingFilteringSection()
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.bottom)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    Button {
                        sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
                    } label: {
                        Text("Restore Defaults")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                    .padding(.bottom, sortingAndFilteringViewModel.applyFiltersButtonVisible ? 55 : 0)
                }
                .padding()
            }
            
            if sortingAndFilteringViewModel.applyFiltersButtonVisible {
                Button {
                    withAnimation {
                        exploreViewModel.restoreOriginalProductsArray()
                        
                        sortingAndFilteringViewModel.applySortingAndFiltering(productsArray: &exploreViewModel.changingProductsToBeDisplayed)
                        dismiss()
                    }
                } label: {
                    Text("Apply")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .transition(.move(edge: .bottom))
                .animation(.default)
                .zIndex(1)
            }
        }
        .navigationTitle("Sorting and Filtering")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if !sortingAndFilteringViewModel.sortingOrFilteringApplied {
                sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
            }
        }
    }
    
    @ViewBuilder
    func buildCompanyFilteringSection() -> some View {
        VStack {
            HStack {
                Text("Company")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Spacer()
                Button {
                    withAnimation {
                        sortingAndFilteringViewModel.companyFilterSectionHidden.toggle()
                    }
                } label: {
                    Image(systemName: sortingAndFilteringViewModel.companyFilterSectionHidden ? "chevron.down" : "chevron.up")
                }
            }
            
            if !sortingAndFilteringViewModel.companyFilterSectionHidden {
                Divider()
                
                LazyVGrid(columns: filtersGridColumns,
                          alignment: .leading,
                          spacing: 10) {
                    ForEach(exploreViewModel.productsCompanies, id: \.self) { company in
                        Button {
                            withAnimation {
                                sortingAndFilteringViewModel.manageCompanyFiltersFor(company: company)
                            }
                        } label: {
                            Text(company)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .foregroundColor(sortingAndFilteringViewModel.companyFilters.contains(company) ?
                                            .accentColor : Color(uiColor: .systemGray4))
                                )
                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .white)
                        }
                    }
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
        }
    }
    
    @ViewBuilder
    func buildCategoryFilteringSection() -> some View {
        VStack {
            HStack {
                Text("Category")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Spacer()
                Button {
                    withAnimation {
                        sortingAndFilteringViewModel.categoryFilterSectionHidden.toggle()
                    }
                } label: {
                    Image(systemName: sortingAndFilteringViewModel.categoryFilterSectionHidden ? "chevron.down" : "chevron.up")
                }
            }
            
            if !sortingAndFilteringViewModel.categoryFilterSectionHidden {
                Divider()
                
                LazyVGrid(columns: filtersGridColumns,
                          alignment: .leading,
                          spacing: 10) {
                    ForEach(exploreViewModel.productsCategories, id: \.self) { category in
                        Button {
                            withAnimation {
                                sortingAndFilteringViewModel.manageCategoryFiltersFor(category: category)
                            }
                        } label: {
                            Text(category.rawValue)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .foregroundColor(sortingAndFilteringViewModel.categoryFilters.contains(category) ?
                                            .accentColor : Color(uiColor: .systemGray4))
                                )
                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .white)
                        }
                    }
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
        }
    }
    
    @ViewBuilder
    func buildPriceFilteringSection() -> some View {
        VStack {
            HStack {
                Text("Price")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Spacer()
                Button {
                    withAnimation {
                        sortingAndFilteringViewModel.priceFilterSectionHidden.toggle()
                    }
                } label: {
                    Image(systemName: sortingAndFilteringViewModel.priceFilterSectionHidden ? "chevron.down" : "chevron.up")
                }
            }
            
            if !sortingAndFilteringViewModel.priceFilterSectionHidden {
                Divider()
                
                HStack {
                    RectangleCustomTextField(textFieldProperty: "From",
                                             textFieldKeyboardType: .decimalPad,
                                             text: $sortingAndFilteringViewModel.lowestPriceFilter,
                                             isFocusedParentView: $isLowestPriceTextFieldFocused)
                    
                    Divider()
                    
                    RectangleCustomTextField(textFieldProperty: "To",
                                             textFieldKeyboardType: .decimalPad,
                                             text: $sortingAndFilteringViewModel.highestPriceFilter,
                                             isFocusedParentView: $isHighestPriceTextFieldFocused)
                }
                
            }
        }
    }
    
    @ViewBuilder
    func buildRatingFilteringSection() -> some View {
        VStack {
            HStack {
                Text("Rating")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Spacer()
                Button {
                    withAnimation {
                        sortingAndFilteringViewModel.ratingFilterSectionHidden.toggle()
                    }
                } label: {
                    Image(systemName: sortingAndFilteringViewModel.ratingFilterSectionHidden ? "chevron.down" : "chevron.up")
                }
            }
            
            if !sortingAndFilteringViewModel.ratingFilterSectionHidden {
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("From")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        HStack {
                            ForEach(0..<sortingAndFilteringViewModel.lowestRatingFilter, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.lowestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star.fill")
                                }
                            }
                            ForEach(sortingAndFilteringViewModel.lowestRatingFilter..<5, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.lowestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star")
                                }
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("To")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        HStack {
                            ForEach(0..<sortingAndFilteringViewModel.highestRatingFilter, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.highestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star.fill")
                                }
                            }
                            ForEach(sortingAndFilteringViewModel.highestRatingFilter..<5, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.highestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star")
                                }
                            }
                        }
                    }
                    .padding(.trailing, 30)
                }
            }
        }
    }
}

struct SortingAndFilteringSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let exploreViewModel = ExploreViewModel()
        let sortingAndFilteringViewModel = SortingAndFilteringViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SortingAndFilteringSheetView()
                    .environmentObject(exploreViewModel)
                    .environmentObject(sortingAndFilteringViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
