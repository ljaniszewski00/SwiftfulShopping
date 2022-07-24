//
//  CartView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(Array(cartViewModel.cart.products.keys), id: \.self) { product in
                    HStack {
                        Text(product.id)
                        
                        Spacer()

                        Text("\(cartViewModel.getCartProductCount(productID: product.id))")
                        
                        Spacer()
                        
                        Button {
                            cartViewModel.removeProductFromCart(productID: product.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Cart")
        }
        .navigationViewStyle(.stack)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
