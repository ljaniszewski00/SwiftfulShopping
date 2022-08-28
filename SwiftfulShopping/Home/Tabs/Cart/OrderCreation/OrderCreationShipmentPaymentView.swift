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
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Text("This will be the delivery addres for package")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.ssGray)
                            .padding(.bottom, 10)
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                HStack(spacing: 5) {
                                    Text(profileViewModel.profile.firstName)
                                    Text(profileViewModel.profile.lastName)
                                }
                                Text(orderCreationViewModel.choosenAddress?.description ?? "")
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    orderCreationViewModel.shouldPresentOrderCreationAddressChangeView = true
                                }
                            } label: {
                                Text("Change address")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Choose delivery method")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        VStack(alignment: .leading) {
                            ForEach(ShippingMethod.allCases, id: \.self) { shippingMethod in
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            orderCreationViewModel.choosenShippingMethod = shippingMethod
                                        }
                                    }, label: {
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
                                    })
                                    
                                    Text(shippingMethod.rawValue)
                                        .font(.system(size: 20, weight: .regular, design: .rounded))
                                }
                                .frame(height: 50)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Choose payment method:")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        VStack(alignment: .leading) {
                            ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            orderCreationViewModel.choosenPaymentMethod = paymentMethod
                                        }
                                    }, label: {
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
                                    })
                                    
                                    Text(paymentMethod.rawValue)
                                        .font(.system(size: 20, weight: .regular, design: .rounded))
                                }
                                .frame(height: 50)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Would you like to receive invoice?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    orderCreationViewModel.toReceiveInvoice = true
                                }
                            }, label: {
                                if orderCreationViewModel.toReceiveInvoice {
                                    Circle()
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                } else {
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                }
                            })
                            
                            Text("Yes")
                                .font(.system(size: 20, weight: .regular, design: .rounded))
                        }
                        .frame(height: 50)
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    orderCreationViewModel.toReceiveInvoice = false
                                }
                            }, label: {
                                if !orderCreationViewModel.toReceiveInvoice {
                                    Circle()
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                } else {
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                }
                            })
                            
                            Text("No")
                                .font(.system(size: 20, weight: .regular, design: .rounded))
                        }
                        .frame(height: 50)
                    }
                }
                .padding()
            }
            
            Button {
                orderCreationViewModel.shouldPresentOrderCreationSummaryView = true
            } label: {
                Text("Summary")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            .buttonStyle(CustomButton())
            .padding(.bottom, 15)
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
            if orderCreationViewModel.choosenShippingMethod == nil {
                orderCreationViewModel.choosenShippingMethod = profileViewModel.profile.defaultShippingMethod
            }
            
            if orderCreationViewModel.choosenPaymentMethod == nil {
                orderCreationViewModel.choosenPaymentMethod = profileViewModel.profile.defaultPaymentMethod
            }
            
            if orderCreationViewModel.choosenAddress == nil {
                orderCreationViewModel.choosenAddress = profileViewModel.profile.address
                orderCreationViewModel.otherAddresses = profileViewModel.profile.otherAddresses
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
