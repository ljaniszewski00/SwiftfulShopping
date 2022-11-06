//
//  ListProductCardTileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/07/2022.
//

import SwiftUI
import Kingfisher
import texterify_ios_sdk

struct ListProductCardTileView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var productImage: UIImage?
    
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
        HStack(alignment: .center) {
            Group {
                if let productImage = productImage {
                    Image(uiImage: productImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width:
                                ScreenBoundsSupplier.shared.getScreenWidth() * 0.45,
                               height:
                                ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                } else {
                    Image(AssetsNames.productPlaceholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width:
                                ScreenBoundsSupplier.shared.getScreenWidth() * 0.45,
                               height:
                                ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                }
            }
            .padding(.trailing)
            .layoutPriority(1)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.company)
                            .font(.ssCaption1)
                            .foregroundColor(.ssDarkGray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(product.name)
                            .font(.ssTitle3)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.ssCallout)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 5)
                    }
                    
                    Spacer()
                    
                    if favoritesViewModel.favoriteProducts.contains(product) {
                        Button {
                            favoritesViewModel.removeFromFavorites(product: product)
                        } label: {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 23, height: 20)
                        }
                    } else {
                        Button {
                            favoritesViewModel.addToFavorites(product: product)
                        } label: {
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 23, height: 20)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        if averageRating != 0 {
                            ForEach(1...Int(floor(averageRating)), id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        
                        ForEach(Int(floor(averageRating))..<5, id: \.self) { _ in
                            Image(systemName: "star")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Text("\(ratingsNumber) \(TexterifyManager.localisedString(key: .listProductCardTileView(.ratings)))")
                        .font(.ssCaption1)
                        .foregroundColor(.ssDarkGray)
                }
                .padding(.bottom, 15)
                
                AddToCartButton {
                    cartViewModel.addProductToCart(product: product,
                                                   quantity: 1)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .onAppear {
            exploreViewModel.getImageForProduct(productImageURLString: product.imagesURLs.first) { image in
                self.productImage = image
            }
        }
    }
}

struct ListProductCardTileView_Previews: PreviewProvider {
    static var previews: some View {
        let exploreViewModel = ExploreViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ListProductCardTileView(product: Product.demoProducts[2],
                                        productRatings: [ProductRating.demoProductsRatings[0]])
                    .environmentObject(exploreViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
