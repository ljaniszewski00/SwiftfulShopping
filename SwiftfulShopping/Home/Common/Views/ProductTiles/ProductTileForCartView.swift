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
                }
                
                Spacer()
                
                if includeButtonsForAmountChange {
                    HStack(spacing: 20) {
                        Button {
                            withAnimation {
                                cartViewModel.removeProductFromCart(product: product, quantity: 1)
                            }
                        } label: {
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text("\(cartViewModel.getCartProductCount(product: product))")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        Button {
                            withAnimation {
                                cartViewModel.addProductToCart(product: product, quantity: 1)
                            }
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
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
