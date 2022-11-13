//
//  OrderCreationShipmentPaymentView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrderCreationShipmentPaymentView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    
    @StateObject private var orderCreationViewModel = OrderCreationViewModel()
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        VStack {
            StepsView(stepsNumber: 4, activeStep: 2)
                .padding(.vertical)
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.consigneeData)))
                            .font(.ssTitle2)
                        
                        Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.thisWillBeTheDeliveryAddress)))
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .padding(.bottom, 15)
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(profileViewModel.profile?.fullName ?? "")
                                    .font(.ssTitle3)
                                Text(orderCreationViewModel.defaultAddress)
                                    .font(.ssCallout).fontWeight(.regular)
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    orderCreationViewModel.shouldPresentOrderCreationAddressChangeView = true
                                }
                            } label: {
                                Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.changeAddress)))
                                    .font(.ssButton)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.chooseDeliveryMethod)))
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
                                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                        
                                        if let currencyCode = LocaleManager.client.clientCurrencyCode,
                                           let shippingMethodPrices = Order.shippingMethodsPrices[shippingMethod],
                                           let shippingMethodPrice = shippingMethodPrices[currencyCode],
                                           let formattedShippingMethodPrice = LocaleManager.client.formatPrice(price: shippingMethodPrice) {
                                            Text(formattedShippingMethodPrice)
                                                .font(.ssCallout)
                                        }
                                    }
                                })
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.choosePaymentMethod)))
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
                                                .foregroundColor(paymentMethod == .cash ? .ssDarkGray : .accentColor)
                                                .frame(width: 25)
                                        }
                                        
                                        Text(paymentMethod.rawValue)
                                            .font(.ssTitle3)
                                            .foregroundColor(paymentMethod == .cash ? .ssDarkGray : (colorScheme == .light ? .black : .ssWhite))
                                        
                                        if paymentMethod != .cash {
                                            if let currencyCode = LocaleManager.client.clientCurrencyCode,
                                               let paymentMethodPrices = Order.paymentMethodPrices[paymentMethod],
                                               let paymentMethodPrice = paymentMethodPrices[currencyCode],
                                               let formattedPaymentMethodPrice = LocaleManager.client.formatPrice(price: paymentMethodPrice) {
                                                Text(formattedPaymentMethodPrice)
                                                    .font(.ssCallout)
                                            }
                                        }
                                        
                                        if paymentMethod == .cash {
                                            Text(TexterifyManager.localisedString(key: .common(.commingSoon)))
                                                .font(.ssCallout)
                                                .padding(5)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke()
                                                        .foregroundColor(.accentColor)
                                                }
                                        }
                                    }
                                })
                                .if(paymentMethod == .cash) {
                                    $0
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.wouldYouLikeToReceiveInvoice)))
                            .font(.ssTitle2)
                        
                        SingleSelectionToggle(selection: $orderCreationViewModel.toReceiveInvoice)
                    }
                }
                .padding()
            }
            
            Button {
                orderCreationViewModel.shouldPresentOrderCreationSummaryView = true
            } label: {
                Text(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.summary)))
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
            .padding()
            .disabled(orderCreationViewModel.cannotProceedToSummaryView)
            
            NavigationLink(destination: OrderCreationSummaryView()
                                            .environmentObject(orderCreationViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationSummaryView,
                           label: { EmptyView() })
            .isDetailLink(false)
            
            NavigationLink(destination: OrderCreationChangeAddressView()
                                            .environmentObject(orderCreationViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationAddressChangeView,
                           label: { EmptyView() })
            .isDetailLink(false)
        }
        .navigationTitle(TexterifyManager.localisedString(key: .orderCreationShipmentPaymentView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .onAppear {
            if let profile = profileViewModel.profile {
                if orderCreationViewModel.defaultAddress.isEmpty {
                    orderCreationViewModel.setupAddresses(defaultProfileAddress:
                                                            profile.defaultShipmentAddress,
                                                          profileAddresses:
                                                            profile.shipmentAddresses)
                }
                
                if orderCreationViewModel.choosenShippingMethod == nil {
                    orderCreationViewModel.choosenShippingMethod = profile.defaultShippingMethod
                }
                
                if orderCreationViewModel.choosenPaymentMethod == nil {
                    orderCreationViewModel.choosenPaymentMethod = profile.defaultPaymentMethod
                }
            }
        }
    }
}

struct OrderCreationShipmentPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationShipmentPaymentView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
