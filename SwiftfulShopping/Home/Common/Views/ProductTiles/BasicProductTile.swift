//
//  ProductTileForRateView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/08/2022.
//

import SwiftUI

struct BasicProductTile: View {
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: product.imagesURLs[0])!) { loadedImage in
                loadedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                Image("product_placeholder_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.trailing)

            VStack(alignment: .leading, spacing: 10) {
                Text(product.company)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(product.name)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 15)
            }
            .padding()
            .padding(.top)
            .padding(.trailing)
        }
    }
}

struct BasicProductTile_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                BasicProductTile(product: Product.demoProducts[0])
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
