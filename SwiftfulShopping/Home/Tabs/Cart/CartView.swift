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
            List {
                ForEach(Array(cartViewModel.cart.products.keys), id: \.self) { product in
                    HStack {
                        Text(product.id)
                        
                        Spacer()

                        HStack {
                            Button {
                                withAnimation {
                                    cartViewModel.removeProductFromCart(product: product, quantity: 1)
                                }
                            } label: {
                                Image(systemName: "minus.square.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            
                            Text("\(cartViewModel.getCartProductCount(product: product))")
                            
                            Button {
                                withAnimation {
                                    cartViewModel.addProductToCart(product: product, quantity: 1)
                                }
                            } label: {
                                Image(systemName: "plus.square.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            cartViewModel.removeProductFromCart(product: product)
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
