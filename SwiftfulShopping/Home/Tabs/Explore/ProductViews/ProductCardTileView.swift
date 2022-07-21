//
//  ProductCardTileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI

struct ProductCardTileView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: product.imageURL)!) { loadedImage in
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.22)
                } placeholder: {
                    Image("product_placeholder_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.22)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 28, height: 25)
                }
            }

            VStack(alignment: .center, spacing: 15) {
                Text(product.company)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                Text(product.name)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                Text("\(product.price, specifier: "%.2f")")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
        }
    }
}

struct ProductCardTileView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductCardTileView(product: Product.demoProducts[0])
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
