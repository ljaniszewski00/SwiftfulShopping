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
    
    @StateObject private var networkNanager = NetworkManager.shared
    
    @State private var productClicked: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if cartViewModel.cartIsEmpty {
                    VStack(spacing: 40) {
                        LottieView(name: "empty_cart", loopMode: .playOnce, contentMode: .scaleAspectFit)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5,
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.25)
                        VStack(spacing: 20) {
                            Text("Your cart is empty")
                                .font(.ssTitle2)
                            Text("If you add any products to your cart in products explorer they will be displayed here")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                } else {
                    VStack {
                        StepsView(stepsNumber: 4, activeStep: 1)
                            .padding(.vertical)
                        
                        List {
                            ForEach(Array(cartViewModel.cart.products.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                                ProductTileForCartView(product: product)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                            cartViewModel.changeFocusedProductFor(product: product)
                                        }
                                    }
                            }
                            .onDelete(perform: cartViewModel.removeProducts)
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Products in cart:")
                                    .font(.ssCallout)
                                    .foregroundColor(.ssDarkGray)
                                
                                Text("\(cartViewModel.cartProductsCount)")
                                    .font(.ssTitle3)
                                    .foregroundColor(.accentColor)
                            }
                            
                            HStack {
                                Text("Total cost:")
                                    .font(.ssCallout)
                                    .foregroundColor(.ssDarkGray)
                                
                                Text("$\(cartViewModel.cartTotalCost, specifier: "%.2f")")
                                    .font(.ssTitle3)
                                    .foregroundColor(.accentColor)
                            }
                            
                            Button {
                                cartViewModel.shouldPresentCheckoutFirstView = true
                            } label: {
                                Text("Checkout")
                                    .font(.ssButton)
                            }
                            .buttonStyle(CustomButton())
                            .disabled(cartViewModel.cartIsEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 70)
                        
                        NavigationLink(destination: ProductDetailsView(product: cartViewModel.choosenProduct ?? Product.demoProducts[0])
                                                        .onAppear {
                                                            tabBarStateManager.hideTabBar()
                                                        },
                                       isActive: $cartViewModel.shouldPresentProductDetailsView,
                                       label: { EmptyView() })
                        
                        NavigationLink(destination: OrderCreationShipmentPaymentView()
                                                        .onAppear {
                                                            tabBarStateManager.hideTabBar()
                                                        },
                                       isActive: $cartViewModel.shouldPresentCheckoutFirstView,
                                       label: { EmptyView() })
                        .isDetailLink(false)
                    }
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
                            .font(.ssButton)
                    }
                    .disabled(cartViewModel.cartIsEmpty)
                }
            }
            .onAppear {
                tabBarStateManager.showTabBar()
            }
        }
        .navigationViewStyle(.stack)
        .environmentObject(authStateManager)
        .environmentObject(tabBarStateManager)
        .environmentObject(exploreViewModel)
        .environmentObject(profileViewModel)
        .environmentObject(favoritesViewModel)
        .environmentObject(cartViewModel)
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
