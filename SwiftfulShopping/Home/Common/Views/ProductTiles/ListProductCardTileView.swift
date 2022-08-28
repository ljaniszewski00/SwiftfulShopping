//
//  ListProductCardTileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/07/2022.
//

import SwiftUI
import Kingfisher

struct ListProductCardTileView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    
    var body: some View {
        HStack(alignment: .center) {
            KFImage(URL(string: product.imagesURLs.first!)!)
                .placeholder {
                    Image("product_placeholder_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .retry(maxCount: 3, interval: .seconds(3))
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.trailing)

            VStack(alignment: .leading, spacing: 10) {
                Text(product.company)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.ssGray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(product.name)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        ForEach(1...Int(round(product.rating.averageRating)), id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.accentColor)
                        }
                        
                        ForEach(Int(round(product.rating.averageRating))..<5, id: \.self) { _ in
                            Image(systemName: "star")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Text("\(product.rating.ratingsNumber) ratings")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.ssGray)
                }
                .padding(.bottom, 15)
                
                HStack {
                    Button {
                        withAnimation {
                            cartViewModel.addProductToCart(product: product, quantity: 1)
                        }
                    } label: {
                        Text("Add to Cart")
                            .fontWeight(.bold)
                            .foregroundColor(.ssWhite)
                            .padding(.all, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                            }
                    }
                    Spacer()
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
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct ListProductCardTileView_Previews: PreviewProvider {
    static var previews: some View {
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ListProductCardTileView(product: Product.demoProducts[0])
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
