//
//  ProductTileForRateView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/08/2022.
//

import SwiftUI
import Kingfisher
import texterify_ios_sdk

struct BasicProductTile: View {
    @EnvironmentObject private var ratingViewModel: RatingViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    var includeRateButton: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: product.imagesURLs.first ?? URLConstants.emptyProductPhoto)!)
                .placeholder {
                    Image(AssetsNames.productPlaceholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width:
                                ScreenBoundsSupplier.shared.getScreenWidth() * 0.45,
                               height:
                                ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                }
                .retry(maxCount: 3, interval: .seconds(3))
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width:
                        ScreenBoundsSupplier.shared.getScreenWidth() * 0.45,
                       height:
                        ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                .padding(.trailing)
                .layoutPriority(1)

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.company)
                            .font(.ssCaption1)
                            .foregroundColor(.ssDarkGray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(product.name)
                            .font(.ssTitle3)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        if let price = product.price, let formattedPrice = LocaleManager.client.formatPrice(price: price) {
                            Text(formattedPrice)
                                .font(.ssCallout)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding(.bottom, 15)
                
                if includeRateButton {
                    Button {
                        withAnimation {
                            ratingViewModel.activeProduct = product
                            ratingViewModel.shouldPresentSingleProductRatingPage = true
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .basicProductTile(.rateProductButton)))
                            .fontWeight(.bold)
                            .foregroundColor(.ssWhite)
                            .padding(.all, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                            }
                    }
                }
            }
        }
        .padding()
    }
}

struct BasicProductTile_Previews: PreviewProvider {
    static var previews: some View {
        let ratingViewModel = RatingViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                BasicProductTile(product: Product.demoProducts[2])
                    .environmentObject(ratingViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
