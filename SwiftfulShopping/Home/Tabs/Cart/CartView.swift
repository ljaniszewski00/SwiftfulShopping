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
                        Button {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                cartViewModel.changeFocusedProductFor(product: product)
                            }
                        } label: {
                            ProductTileForCartView(product: product)
                                .environmentObject(cartViewModel)
                        }
                        .buttonStyle(ScaledButtonStyle())
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
                        cartViewModel.shouldPresentCheckoutFirstView = true
                    } label: {
                        Text("Checkout")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton())
                    .padding(.bottom, 15)
                    .disabled(cartViewModel.cartIsEmpty)
                }
                .padding(.bottom, 70)
                
                NavigationLink(destination: ProductDetailsView(product: cartViewModel.choosenProduct ?? Product.demoProducts[0])
                                                .environmentObject(authStateManager)
                                                .environmentObject(tabBarStateManager)
                                                .environmentObject(exploreViewModel)
                                                .environmentObject(profileViewModel)
                                                .environmentObject(favoritesViewModel)
                                                .environmentObject(cartViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $cartViewModel.shouldPresentProductDetailsView,
                               label: { EmptyView() })
                
                NavigationLink(destination: OrderCreationShipmentPaymentView()
                                                .environmentObject(authStateManager)
                                                .environmentObject(tabBarStateManager)
                                                .environmentObject(exploreViewModel)
                                                .environmentObject(profileViewModel)
                                                .environmentObject(favoritesViewModel)
                                                .environmentObject(cartViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $cartViewModel.shouldPresentCheckoutFirstView,
                               label: { EmptyView() })
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
            .onAppear {
                tabBarStateManager.showTabBar()
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
                    .environmentObject(favoritesViewModel)
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
