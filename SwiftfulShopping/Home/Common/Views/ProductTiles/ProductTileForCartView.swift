//
//  ProductTileForCartView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI
import Kingfisher

struct ProductTileForCartView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    var includeButtonsForAmountChange: Bool = true
    
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
                .padding([.vertical, .trailing])

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.company)
                        .font(.ssCallout)
                        .foregroundColor(.ssDarkGray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(product.name)
                        .font(.ssTitle2)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
                .padding(.bottom)
                
                Spacer()
                
                if includeButtonsForAmountChange {
                    QuantityInput(quantity: cartViewModel.getCartProductCount(product: product),
                                  minusAction: {
                        cartViewModel.removeProductFromCart(product: product, quantity: 1)
                    },
                                  plusAction: {
                        cartViewModel.addProductToCart(product: product, quantity: 1)
                    })
                }
            }
            .padding()
        }
    }
}

struct ProductTileForCartView_Previews: PreviewProvider {
    static var previews: some View {
        let cartViewModel = CartViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductTileForCartView(product: Product.demoProducts[0])
                    .environmentObject(cartViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
