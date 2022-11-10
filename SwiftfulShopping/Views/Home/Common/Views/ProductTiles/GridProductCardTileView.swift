//
//  GridProductCardTileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI
import Kingfisher
import texterify_ios_sdk

struct GridProductCardTileView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    var productRatings: [ProductRating]
    
    var averageRating: Double {
        if productRatings.isEmpty {
            return 0
        } else {
            return Double(productRatings.reduce(0, { $0 + $1.rating })) / Double(productRatings.count)
        }
    }
    
    var reviewsNumber: Int {
        productRatings.filter { $0.review != nil }.count
    }

    var ratingsNumber: Int {
        productRatings.count
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(URL(string: product.imagesURLs.first ?? URLConstants.emptyProductPhoto)!)
                .placeholder {
                    Image(AssetsNames.productPlaceholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width:
                                ScreenBoundsSupplier.shared.getScreenWidth() * 0.6,
                               height:
                                ScreenBoundsSupplier.shared.getScreenHeight() * 0.3)
                }
                .retry(maxCount: 3, interval: .seconds(3))
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width:
                        ScreenBoundsSupplier.shared.getScreenWidth() * 0.6,
                       height:
                        ScreenBoundsSupplier.shared.getScreenHeight() * 0.3)
                .padding(.vertical)
                .layoutPriority(1)

            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(product.company)
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(product.name)
                            .font(.ssTitle2)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        if let price = product.price,
                           let formattedPrice = LocaleManager.client.formatPrice(price: price) {
                            Text(formattedPrice)
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack {
                            if averageRating != 0 {
                                ForEach(1...Int(floor(averageRating)), id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            
                            ForEach(Int(floor(averageRating))..<5, id: \.self) { _ in
                                Image(systemName: "star")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        
                        Text("\(ratingsNumber) \(TexterifyManager.localisedString(key: .gridProductCardTileView(.ratings)))")
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                    }
                }
                .padding(.bottom, 30)
                
                ZStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        AddToCartButton {
                            cartViewModel.addProductToCart(product: product,
                                                           quantity: 1)
                        }
                        Spacer()
                    }
                    
                    if favoritesViewModel.favoriteProducts.contains(product) {
                        Button {
                            favoritesViewModel.removeFromFavorites(product: product)
                        } label: {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 28, height: 25)
                        }
                    } else {
                        Button {
                            favoritesViewModel.addToFavorites(product: product)
                        } label: {
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 28, height: 25)
                        }
                    }
                }
            }
            .padding()
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct GridProductCardTileView_Previews: PreviewProvider {
    static var previews: some View {
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                GridProductCardTileView(product: Product.demoProducts[1],
                                        productRatings: [ProductRating.demoProductsRatings[0]])
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
