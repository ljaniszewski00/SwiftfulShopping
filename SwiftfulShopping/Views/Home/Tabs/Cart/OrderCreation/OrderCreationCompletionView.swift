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
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    StepsView(stepsNumber: 4, activeStep: 4)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("You have successfuly placed your order!")
                                .font(.ssTitle2)
                            
                            Text("Please wait patiently for it to be delivered")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                        }
                        
                        HStack {
                            Spacer()
                            LottieView(name: "successful_order_creation", loopMode: .playOnce, contentMode: .scaleAspectFill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5,
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.25)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 30) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Order number:")
                                    .font(.ssTitle3)
                                Text(orderCreationViewModel.createdOrder?.id ?? "")
                                    .font(.ssCallout)
                                    .foregroundColor(.accentColor)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Expected delivery date:")
                                    .font(.ssTitle3)
                                Text(orderCreationViewModel.createdOrder?.estimatedDeliveryDate.dateString() ?? "")
                                    .font(.ssCallout)
                                    .foregroundColor(.accentColor)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            cartViewModel.removeAllProductsFromCart()
                            cartViewModel.shouldPresentCheckoutFirstView = false
                        }
                    } label: {
                        Text("Go back to cart")
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .navigationTitle("Order placed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct OrderCreationCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager()
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
                        authStateManager.didLogged(with: .emailPassword)
                        orderCreationViewModel.createdOrder = Order.demoOrders[0]
                    }
            }
        }
    }
}
