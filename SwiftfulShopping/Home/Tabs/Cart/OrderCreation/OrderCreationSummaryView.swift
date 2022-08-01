//
//  OrderCreationSummaryView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI

struct OrderCreationSummaryView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            StepsView(stepsNumber: 4, activeStep: 3)
                .padding(.vertical)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Consignee Data")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        Text("This will be the delivery addres for package")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 5) {
                                Text(profileViewModel.profile.firstName)
                                Text(profileViewModel.profile.lastName)
                            }
                            Text(orderCreationViewModel.choosenAddress?.description ?? "")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Shipping Method")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke()
                                .foregroundColor(.accentColor)
                            Text(orderCreationViewModel.choosenShippingMethod?.rawValue ?? "")
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Payment Method")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke()
                                .foregroundColor(.accentColor)
                            Text(orderCreationViewModel.choosenPaymentMethod?.rawValue ?? "")
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                    }
                    
                    Text(orderCreationViewModel.toReceiveInvoice ? "I would like to receive invoice" : "I don't want to receive invoice")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Products")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        ForEach(Array(cartViewModel.cart.products.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                            ProductTileForCartView(product: product, includeButtonsForAmountChange: false)
                                .environmentObject(cartViewModel)
                                .padding()
                        }
                    }
                }
                .padding()
            }
            
            Button {
                orderCreationViewModel.createOrder(client: profileViewModel.profile, shoppingCart: cartViewModel.cart)
                profileViewModel.orders.append(orderCreationViewModel.createdOrder!)
                orderCreationViewModel.shouldPresentOrderCreationCompletionView = true
            } label: {
                Text("Complete")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            .buttonStyle(CustomButton())
            .padding(.bottom, 15)
            
            NavigationLink(destination: OrderCreationCompletionView()
                                            .environmentObject(authStateManager)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(exploreViewModel)
                                            .environmentObject(profileViewModel)
                                            .environmentObject(favoritesViewModel)
                                            .environmentObject(cartViewModel)
                                            .environmentObject(orderCreationViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            }
                                            .onDisappear {
                                                tabBarStateManager.showTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationCompletionView,
                           label: { EmptyView() })
        }
        .navigationTitle("Order Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OrderCreationSummaryView_Previews: PreviewProvider {
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
                OrderCreationSummaryView()
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
                        orderCreationViewModel.choosenShippingMethod = .parcel
                        orderCreationViewModel.choosenAddress = Address.demoAddress
                        orderCreationViewModel.choosenPaymentMethod = PaymentMethod.creditCard
                        orderCreationViewModel.createdOrder = Order.demoOrders[0]
                        cartViewModel.cart.products = [Product.demoProducts[0]: 2,
                                                       Product.demoProducts[1]: 1,
                                                       Product.demoProducts[2]: 3,
                                                       Product.demoProducts[3]: 1]
                    }
            }
        }
    }
}
