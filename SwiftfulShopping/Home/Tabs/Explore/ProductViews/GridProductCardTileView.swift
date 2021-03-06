//
//  GridProductCardTileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI

struct GridProductCardTileView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            AsyncImage(url: URL(string: product.imageURL)!) { loadedImage in
                loadedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                Image("product_placeholder_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            VStack(alignment: .center, spacing: 15) {
                Text(product.company)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(product.name)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                
                Text("\(product.price, specifier: "%.2f")")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 15)
                
                ZStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                cartViewModel.addProductToCart(product: product, quantity: 1)
                            }
                        } label: {
                            Text("Add to Cart")
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .padding(.all, 10)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                }
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
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
        }
    }
}

struct GridProductCardTileView_Previews: PreviewProvider {
    static var previews: some View {
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                GridProductCardTileView(product: Product.demoProducts[0])
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
