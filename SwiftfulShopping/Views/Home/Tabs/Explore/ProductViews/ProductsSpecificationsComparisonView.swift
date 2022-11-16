//
//  ProductsSpecificationsComparisonView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/11/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ProductsSpecificationsComparisonView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var showDifferences: Bool = false
    
    var body: some View {
        VStack {
            if exploreViewModel.productsToBeCompared.isEmpty {
                VStack(spacing: 15) {
                    LottieView(name: LottieAssetsNames.scale,
                               loopMode: .loop,
                               contentMode: .scaleAspectFill)
                        .frame(width: 200, height: 200)
                    Text(TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.emptyComparisonTitle)))
                        .font(.ssTitle2)
                    Text(getClickButtonText())
                        .font(.ssCallout)
                        .foregroundColor(.ssDarkGray)
                    Spacer()
                }
                .padding(.top, 100)
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text(exploreViewModel.productsToBeComparedCategory?.rawValue ?? "")
                            .font(.ssTitle3)
                        Spacer()
                        Button {
                            showDifferences.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.line.vertical.and.square.filled")
                                Text(TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.differencesButton)))
                            }
                        }
                        .disabled(exploreViewModel.productsToBeCompared.count < 2)
                    }
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ScrollView(.vertical, showsIndicators: false) {
                                HStack {
                                    ForEach(exploreViewModel.productsToBeCompared.sorted { $0.name < $1.name }, id: \.id) { product in
                                        VStack {
                                            ZStack(alignment: .topLeading) {
                                                BasicProductTile(product: product)
                                                Button {
                                                    exploreViewModel.removeProductToBeCompared(product: product)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundColor(.accentColor)
                                                }
                                            }
                                            Divider()
                                            if let productSpecificationKeys = getProductSpecificationKeys(product: product),
                                                let productSpecification = exploreViewModel.getProductSpecificationForProductDetails(product: product) {
                                                VStack(alignment: .leading, spacing: 20) {
                                                    ForEach(productSpecificationKeys, id: \.self) { specificationKey in
                                                        VStack(alignment: .leading) {
                                                            VStack(alignment: .leading, spacing: 13) {
                                                                Text(specificationKey)
                                                                    .font(.ssCallout)
                                                                    .foregroundColor(.ssDarkGray)
                                                                Group {
                                                                    if let productSpecificationValue = productSpecification[specificationKey] {
                                                                        if !productSpecificationValue.isEmpty {
                                                                            Text(formatProductSpecificationValue(specificationValue: productSpecificationValue))
                                                                        } else {
                                                                            Text(TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.noInformation)))
                                                                        }
                                                                    } else {
                                                                        Text(TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.noInformation)))
                                                                    }
                                                                }
                                                                .font(.ssCallout)
                                                                .foregroundColor(showDifferences ? (getKeysWithDifferentValuesForProducts().contains(specificationKey) ? .red : (colorScheme == .light ? .black : .ssWhite)) : (colorScheme == .light ? .black : .ssWhite))
                                                                .fixedSize(horizontal: false, vertical: true)
                                                                .frame(height: 100, alignment: .top)
                                                            }
                                                            Divider()
                                                        }
                                                    }
                                                }
                                                .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        
                                        if product != exploreViewModel.productsToBeCompared.sorted { $0.name < $1.name }.last {
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle(TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    exploreViewModel.removeAllProductsFromComparison()
                } label: {
                    Text(TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.removeAllFromComparisonButton)))
                }
                .disabled(exploreViewModel.productsToBeCompared.isEmpty)
            }
        }
    }
    
    private func getClickButtonText() -> String {
        var clickButtonText = TexterifyManager.localisedString(key: .productsSpecificationComparisonView(.emptyComparisonInfo))
        let substring = " "
        
        let indices = getIndexesOfOcurrencesOf(substring, in: clickButtonText)
        
        clickButtonText.insert(contentsOf: " ⚖", at: indices[1])
        return clickButtonText
    }
    
    private func getKeysWithDifferentValuesForProducts() -> [String] {
        var keysWithDifferences: Set<String> = []
        for productToCompare in exploreViewModel.productsToBeCompared {
            if let specificationToCompare = exploreViewModel.getProductSpecificationForProductDetails(product: productToCompare) {
                for productToBeCompared in exploreViewModel.productsToBeCompared {
                    if let specificationsKeysToBeCompared = getProductSpecificationKeys(product: productToBeCompared) {
                        if let specificationToBeCompared = exploreViewModel.getProductSpecificationForProductDetails(product: productToBeCompared) {
                            for specificationKey in specificationsKeysToBeCompared {
                                if keysWithDifferences.contains(specificationKey) {
                                    break
                                }
                                
                                if let specificationToCompareValue = specificationToCompare[specificationKey],
                                   let specificationToBeComparedValue = specificationToBeCompared[specificationKey] {
                                    if specificationToCompareValue != specificationToBeComparedValue {
                                        keysWithDifferences.insert(specificationKey)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return Array(keysWithDifferences)
    }
    
    private func getProductSpecificationKeys(product: Product) -> [String]? {
        if let productSpecification = exploreViewModel.getProductSpecificationForProductDetails(product: product) {
            return Array(productSpecification.keys).sorted { $0 < $1 }
        } else {
            return nil
        }
    }
    
    private func formatProductSpecificationValue(specificationValue: String) -> String {
        specificationValue.replacingOccurrences(of: ", ", with: "\n")
    }
}

struct ProductsSpecificationsComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        let exploreViewModel = ExploreViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsSpecificationsComparisonView()
                    .environmentObject(exploreViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
//                    .onAppear {
//                        exploreViewModel.productsToBeCompared = [Product.demoProducts[6],
//                                                                 Product.demoProducts[7]]
//                    }
            }
        }
    }
}
