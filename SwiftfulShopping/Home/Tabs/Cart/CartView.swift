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
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var productClicked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                StepsView(stepsNumber: 4, activeStep: 1)
                    .padding(.vertical)
                
                List {
                    ForEach(Array(cartViewModel.cart.products.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                        VStack {
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
                                        .padding(.bottom, 15)
                                    
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
                        }
                        .padding()
                    }
                    .onDelete(perform: cartViewModel.removeProducts)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Products in cart:")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                        
                        Text("\(cartViewModel.cartProductsCount)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    
                    HStack {
                        Text("Total cost:")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                        
                        Text("\(cartViewModel.cartTotalCost, specifier: "%.2f")")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Checkout")
                    }
                    .buttonStyle(CustomButton())
                    .padding(.bottom, 15)
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cartViewModel.removeAllProductsFromCart()
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
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CartView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
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
