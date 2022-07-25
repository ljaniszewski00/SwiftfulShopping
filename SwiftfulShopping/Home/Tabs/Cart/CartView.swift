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
                StepsView(stepsNumber: 4, activeStep: 1)
                    .padding(.vertical)
                
                List {
                    ForEach(Array(cartViewModel.cart.products.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                        HStack {
                            Text(product.id)
                            
                            Spacer()

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
                        }
                        .padding()
                    }
                    .onDelete(perform: cartViewModel.removeProducts)
                }
                
                Button {
                    cartViewModel.removeAllProductsFromCart()
                } label: {
                    Text("Checkout")
                }
                .buttonStyle(CustomButton())
                .padding(.bottom, 15)
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Clean cart")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let cartViewModel = CartViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CartView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(cartViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        
                        for product in Product.demoProducts {
                            cartViewModel.cart.products[product] = 1
                        }
                    }
            }
        }
    }
}
