//
//  ProductTileForCartView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI

struct ProductTileForCartView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    var includeButtonsForAmountChange: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BasicProductTile(product: product)
                .padding(.bottom, 10)
            
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
                }
                .padding()
            }
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
