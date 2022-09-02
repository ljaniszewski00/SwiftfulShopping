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
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Consignee Data")
                            .font(.ssTitle2)
                        
                        Text("This will be the delivery addres for package")
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .padding(.bottom, 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 5) {
                                Text(profileViewModel.profile.firstName)
                                    .font(.ssTitle3)
                                Text(profileViewModel.profile.lastName)
                                    .font(.ssTitle3)
                            }
                            Text(orderCreationViewModel.defaultAddress)
                                .font(.ssCallout).fontWeight(.regular)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Shipping Method")
                            .font(.ssTitle2)
                        
                        Text(orderCreationViewModel.choosenShippingMethod?.rawValue ?? "")
                            .font(.ssTitle3)
                            .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Payment Method")
                            .font(.ssTitle2)
                        
                        Text(orderCreationViewModel.choosenPaymentMethod?.rawValue ?? "")
                            .font(.ssTitle3)
                            .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Would you like to receive invoice?")
                            .font(.ssTitle2)
                        
                        SingleSelectionToggle(selection: $orderCreationViewModel.toReceiveInvoice)
                            .disabled(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Products")
                            .font(.ssTitle2)
                        
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
                if let desiredAddress = profileViewModel.getAddressFor(addressDescription: orderCreationViewModel.defaultAddress) {
                    orderCreationViewModel.createOrder(client: profileViewModel.profile,
                                                       shoppingCart: cartViewModel.cart,
                                                       shippingAddress: desiredAddress)
                    profileViewModel.orders.append(orderCreationViewModel.createdOrder!)
                    orderCreationViewModel.shouldPresentOrderCreationCompletionView = true
                }
            } label: {
                Text("Complete")
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
            .padding()
            
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
                        orderCreationViewModel.defaultAddress = Address.demoAddress.description
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
