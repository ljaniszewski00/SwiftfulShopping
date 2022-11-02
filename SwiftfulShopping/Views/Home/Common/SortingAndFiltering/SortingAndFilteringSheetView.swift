//
//  SortingAndFilteringSheetView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI
import texterify_ios_sdk

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
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack {
                            HStack {
                                Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.sortBy)))
                                    .font(.ssTitle1)
                                Spacer()
                                Button {
                                    withAnimation {
                                        sortingAndFilteringViewModel.sortingSectionHidden.toggle()
                                    }
                                } label: {
                                    Image(systemName: sortingAndFilteringViewModel.sortingSectionHidden ? "chevron.down" : "chevron.up")
                                }
                            }
                            
                            Divider()
                        }
                        .padding()
                        
                        if !sortingAndFilteringViewModel.sortingSectionHidden {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(SortingMethods.allCases, id: \.self) { sortingMethod in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Button {
                                            withAnimation {
                                                sortingAndFilteringViewModel.sortingMethod = sortingMethod
                                                sortingAndFilteringViewModel.applySorting(productsArray: &exploreViewModel.changingProductsToBeDisplayed)
                                            }
                                        } label: {
                                            HStack {
                                                if sortingAndFilteringViewModel.sortingMethod == sortingMethod {
                                                    Image(systemName: "checkmark")
                                                }
                                                Text(sortingMethod.rawValue)
                                                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                                    .font(.ssTitle3)
                                                Spacer()
                                            }
                                        }
                                        
                                        Divider()
                                            .if(sortingAndFilteringViewModel.sortingMethod == sortingMethod) {
                                                $0
                                                    .overlay(Color.accentColor)
                                            }
                                    }
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack {
                            HStack {
                                Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.filterBy)))
                                    .font(.ssTitle1)
                                Spacer()
                                Button {
                                    withAnimation {
                                        sortingAndFilteringViewModel.filteringSectionHidden.toggle()
                                    }
                                } label: {
                                    Image(systemName: sortingAndFilteringViewModel.filteringSectionHidden ? "chevron.down" : "chevron.up")
                                }
                            }
                            
                            Divider()
                        }
                        .padding()
                        
                        if !sortingAndFilteringViewModel.filteringSectionHidden {
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
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                        }
                    }
                    
                    Button {
                        sortingAndFilteringViewModel.restoreDefaults(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
                    } label: {
                        Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.restoreDefaultsButton)))
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                    .padding(.bottom, sortingAndFilteringViewModel.applyFiltersButtonVisible ? 65 : 0)
                }
                .padding()
            }
            .background {
                Color(uiColor: .secondarySystemBackground)
                    .ignoresSafeArea()
            }
            
            if sortingAndFilteringViewModel.applyFiltersButtonVisible {
                Button {
                    withAnimation {
                        exploreViewModel.restoreOriginalProductsArray()
                        
                        sortingAndFilteringViewModel.applyFiltering(productsArray: &exploreViewModel.changingProductsToBeDisplayed)
                        dismiss()
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.applyButton)))
                        .font(.ssButton)
                }
                .padding()
                .buttonStyle(CustomButton())
                .transition(.move(edge: .bottom))
                .animation(.default)
                .zIndex(1)
            }
        }
        .navigationTitle(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if !sortingAndFilteringViewModel.filteringApplied {
                sortingAndFilteringViewModel.sheetDismissedWithNoFilteringApplied(originalProductsArray: exploreViewModel.productsFromRepository, currentProductsArray: &exploreViewModel.changingProductsToBeDisplayed)
            }
        }
    }
    
    @ViewBuilder
    func buildCompanyFilteringSection() -> some View {
        VStack {
            HStack {
                Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.company)))
                    .font(.ssTitle2)
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
                                        .foregroundColor(sortingAndFilteringViewModel.companyFiltersToApply.contains(company) ?
                                            .accentColor : Color(uiColor: .systemGray4))
                                )
                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .ssWhite)
                        }
                    }
                }
                .font(.ssTitle3)
            }
        }
    }
    
    @ViewBuilder
    func buildCategoryFilteringSection() -> some View {
        VStack {
            HStack {
                Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.category)))
                    .font(.ssTitle2)
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
                                        .foregroundColor(sortingAndFilteringViewModel.categoryFiltersToApply.contains(category) ?
                                            .accentColor : Color(uiColor: .systemGray4))
                                )
                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .ssWhite)
                        }
                    }
                }
                .font(.ssTitle3)
            }
        }
    }
    
    @ViewBuilder
    func buildPriceFilteringSection() -> some View {
        VStack {
            HStack {
                Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.price)))
                    .font(.ssTitle2)
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
                    RectangleCustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.fromTextField)),
                                             textFieldKeyboardType: .decimalPad,
                                             text: $sortingAndFilteringViewModel.lowestPriceFilter,
                                             isFocusedParentView: $isLowestPriceTextFieldFocused)
                    
                    Divider()
                    
                    RectangleCustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.toTextField)),
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
                Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.rating)))
                    .font(.ssTitle2)
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
                        Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.fromRatingLabel)))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        HStack {
                            ForEach(0..<sortingAndFilteringViewModel.lowestRatingFilter, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.lowestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                }
                            }
                            ForEach(sortingAndFilteringViewModel.lowestRatingFilter..<5, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.lowestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star")
                                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                }
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .sortingAndFilteringSheetView(.toRatingLabel)))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        HStack {
                            ForEach(0..<sortingAndFilteringViewModel.highestRatingFilter, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.highestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                }
                            }
                            ForEach(sortingAndFilteringViewModel.highestRatingFilter..<5, id: \.self) { starsNumber in
                                Button {
                                    sortingAndFilteringViewModel.highestRatingFilter = starsNumber + 1
                                } label: {
                                    Image(systemName: "star")
                                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
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
