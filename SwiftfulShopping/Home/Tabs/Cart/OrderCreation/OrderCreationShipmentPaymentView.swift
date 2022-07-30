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
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        Text("This will be the delivery addres for package")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                HStack(spacing: 5) {
                                    Text(profileViewModel.profile.firstName)
                                    Text(profileViewModel.profile.lastName)
                                }
                                Text(profileViewModel.profile.address.description)
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("Change address")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Payment")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                            Button {
                                withAnimation {
                                    orderCreationViewModel.choosenPaymentMethod = paymentMethod
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .if(orderCreationViewModel.choosenPaymentMethod != paymentMethod) {
                                            $0
                                                .stroke()
                                        }
                                    Text(paymentMethod.rawValue)
                                        .foregroundColor(orderCreationViewModel.choosenPaymentMethod == paymentMethod ? .white : .accentColor)
                                        .padding()
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Text("Would you like to receive invoice?")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                        
                        Spacer()
                        
                        Toggle("", isOn: $orderCreationViewModel.toReceiveInvoice)
                            .toggleStyle(CheckMarkToggleStyle())
                            .padding(.trailing, 10)
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
        }
        .navigationTitle("Shipment and Payment")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            orderCreationViewModel.choosenAddress = profileViewModel.profile.address
            orderCreationViewModel.choosenPaymentMethod = profileViewModel.profile.defaultPaymentMethod
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
