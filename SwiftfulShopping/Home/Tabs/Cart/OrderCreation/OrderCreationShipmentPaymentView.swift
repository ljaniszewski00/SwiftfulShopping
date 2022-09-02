//
//  OrderCreationShipmentPaymentView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI

struct OrderCreationShipmentPaymentView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @StateObject private var orderCreationViewModel = OrderCreationViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            StepsView(stepsNumber: 4, activeStep: 2)
                .padding(.vertical)
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Consignee Data")
                            .font(.ssTitle2)
                        
                        Text("This will be the delivery addres for package")
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .padding(.bottom, 15)
                        
                        HStack(alignment: .bottom) {
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
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    orderCreationViewModel.shouldPresentOrderCreationAddressChangeView = true
                                }
                            } label: {
                                Text("Change address")
                                    .font(.ssButton)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Choose delivery method")
                            .font(.ssTitle2)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(ShippingMethod.allCases, id: \.self) { shippingMethod in
                                Button(action: {
                                    withAnimation {
                                        orderCreationViewModel.choosenShippingMethod = shippingMethod
                                    }
                                }, label: {
                                    HStack(spacing: 15) {
                                        if orderCreationViewModel.choosenShippingMethod == shippingMethod {
                                            Circle()
                                                .foregroundColor(.accentColor)
                                                .frame(width: 25)
                                        } else {
                                            Circle()
                                                .stroke(lineWidth: 3)
                                                .foregroundColor(.accentColor)
                                                .frame(width: 25)
                                        }
                                        
                                        Text(shippingMethod.rawValue)
                                            .font(.ssTitle3)
                                            .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                                    }
                                })
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Choose payment method:")
                            .font(.ssTitle2)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                                Button(action: {
                                    withAnimation {
                                        orderCreationViewModel.choosenPaymentMethod = paymentMethod
                                    }
                                }, label: {
                                    HStack(spacing: 15) {
                                        if orderCreationViewModel.choosenPaymentMethod == paymentMethod {
                                            Circle()
                                                .foregroundColor(.accentColor)
                                                .frame(width: 25)
                                        } else {
                                            Circle()
                                                .stroke(lineWidth: 3)
                                                .foregroundColor(.accentColor)
                                                .frame(width: 25)
                                        }
                                        
                                        Text(paymentMethod.rawValue)
                                            .font(.ssTitle3)
                                            .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                                    }
                                })
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Would you like to receive invoice?")
                            .font(.ssTitle2)
                        
                        SingleSelectionToggle(selection: $orderCreationViewModel.toReceiveInvoice)
                    }
                }
                .padding()
            }
            
            Button {
                orderCreationViewModel.shouldPresentOrderCreationSummaryView = true
            } label: {
                Text("Summary")
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
            .padding()
            .disabled(orderCreationViewModel.cannotProceedToSummaryView)
            
            NavigationLink(destination: OrderCreationSummaryView()
                                            .environmentObject(authStateManager)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(exploreViewModel)
                                            .environmentObject(profileViewModel)
                                            .environmentObject(favoritesViewModel)
                                            .environmentObject(cartViewModel)
                                            .environmentObject(orderCreationViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationSummaryView,
                           label: { EmptyView() })
            
            NavigationLink(destination: OrderCreationChangeAddressView()
                                            .environmentObject(profileViewModel)
                                            .environmentObject(orderCreationViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationAddressChangeView,
                           label: { EmptyView() })
        }
        .navigationTitle("Shipment and Payment")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if orderCreationViewModel.defaultAddress.isEmpty {
                orderCreationViewModel.setupAddresses(defaultProfileAddress:
                                                        profileViewModel.profile.defaultAddress,
                                                      profileAddresses:
                                                        profileViewModel.profile.addresses)
            }
            
            if orderCreationViewModel.choosenShippingMethod == nil {
                orderCreationViewModel.choosenShippingMethod = profileViewModel.profile.defaultShippingMethod
            }
            
            if orderCreationViewModel.choosenPaymentMethod == nil {
                orderCreationViewModel.choosenPaymentMethod = profileViewModel.profile.defaultPaymentMethod
            }
        }
    }
}

struct OrderCreationShipmentPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationShipmentPaymentView()
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
                    }
            }
        }
    }
}
