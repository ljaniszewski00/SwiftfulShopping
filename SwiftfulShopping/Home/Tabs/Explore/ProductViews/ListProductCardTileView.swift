//
//  ListProductCardTileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/07/2022.
//

import SwiftUI

struct ListProductCardTileView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    
    var body: some View {
        HStack(alignment: .center) {
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

            VStack(alignment: .leading, spacing: 15) {
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
                
                HStack {
                    Spacer()
                    Button {
                        favoritesViewModel.manageFavoritesFor(product: product)
                    } label: {
                        Image(systemName: favoritesViewModel.favoriteProductsIDs.contains(product.id) ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 28, height: 25)
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

struct ListProductCardTileView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ListProductCardTileView(product: Product.demoProducts[0])
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
