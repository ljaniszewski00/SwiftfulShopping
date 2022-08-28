//
//  OrderCreationCompletionView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI

struct OrderCreationCompletionView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    var body: some View {
        if orderCreationViewModel.shouldPresentCartView {
            withAnimation {
                CartView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .navigationBarHidden(true)
            }
        } else {
            VStack(alignment: .center) {
                StepsView(stepsNumber: 4, activeStep: 4)
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("You have successfuly placed your order!")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        Text("Please wait patiently for it to be delivered")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.ssGray)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 15) {
                            Text("Order number:")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                            Spacer()
                            Text(orderCreationViewModel.createdOrder?.id ?? "")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack(spacing: 15) {
                            Text("Expected delivery date:")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                            Spacer()
                            Text(orderCreationViewModel.createdOrder?.estimatedDeliveryDate.dateString() ?? "")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                Button {
                    withAnimation {
                        cartViewModel.cart.removeAllProductsFromCart()
                        cartViewModel.shouldPresentCheckoutFirstView = false
                        orderCreationViewModel.shouldPresentCartView = true
                    }
                } label: {
                    Text("Go back to cart")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .padding(.bottom, 15)
            }
            .navigationTitle("Order placed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct OrderCreationCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let orderCreationViewModel = OrderCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationCompletionView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(orderCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        orderCreationViewModel.createdOrder = Order.demoOrders[0]
                    }
            }
        }
    }
}
