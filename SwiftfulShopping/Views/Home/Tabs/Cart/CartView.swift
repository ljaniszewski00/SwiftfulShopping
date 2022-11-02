//
//  CartView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct CartView: View {
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
                            Text(TexterifyManager.localisedString(key: .cartView(.yourCartIsEmpty)))
                                .font(.ssTitle2)
                            Text(TexterifyManager.localisedString(key: .cartView(.ifYouAddAnyProducts)))
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
                            ForEach(Array(cartViewModel.productsForCart.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                                ProductTileForCartView(product: product)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                            cartViewModel.changeFocusedProductFor(product: product)
                                        }
                                    }
                            }
                            .onDelete(perform: cartViewModel.removeProducts)
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(TexterifyManager.localisedString(key: .cartView(.productsInCart)))
                                        .font(.ssCallout)
                                        .foregroundColor(.ssDarkGray)
                                    
                                    Text("\(cartViewModel.cartAllProductsQuantityCount)")
                                        .font(.ssTitle3)
                                        .foregroundColor(.accentColor)
                                }
                                
                                HStack {
                                    Text(TexterifyManager.localisedString(key: .cartView(.totalCost)))
                                        .font(.ssCallout)
                                        .foregroundColor(.ssDarkGray)
                                    
                                    Text("$\(cartViewModel.cartTotalCost, specifier: "%.2f")")
                                        .font(.ssTitle3)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.trailing, 40)
                            
                            Button {
                                cartViewModel.shouldPresentCheckoutFirstView = true
                            } label: {
                                Text(TexterifyManager.localisedString(key: .cartView(.checkout)))
                                    .font(.ssButton)
                            }
                            .buttonStyle(CustomButton())
                            .disabled(cartViewModel.cartIsEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                        
                        NavigationLink(destination: ProductDetailsView(product: cartViewModel.choosenProduct ??
                                                                       Product.demoProducts[0],
                                                                       productRatings: exploreViewModel.getRatingsFor(product: cartViewModel.choosenProduct ?? Product.demoProducts[0]))
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
            .navigationTitle(TexterifyManager.localisedString(key: .cartView(.navigationTitle)))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cartViewModel.removeAllProductsFromCart()
                    } label: {
                        Text(TexterifyManager.localisedString(key: .cartView(.toolbarButtonCleanCart)))
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
        .environmentObject(tabBarStateManager)
        .environmentObject(exploreViewModel)
        .environmentObject(profileViewModel)
        .environmentObject(favoritesViewModel)
        .environmentObject(cartViewModel)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CartView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        for product in Product.demoProducts {
                            cartViewModel.productsForCart[product] = 1
                        }
                    }
            }
        }
    }
}
