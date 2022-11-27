//
//  OrderCreationCompletionView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI
import texterify_ios_sdk
import StripePaymentSheet

struct OrderCreationCompletionView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    @EnvironmentObject private var stripeViewModel: StripeViewModel
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var errorManager: ErrorManager = ErrorManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    StepsView(stepsNumber: 4, activeStep: 4)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.youHaveSuccessfullyPlacedYourOrder)))
                                .font(.ssTitle2)
                            
                            Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.pleaseWaitPatiently)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                        }
                        
                        HStack {
                            Spacer()
                            LottieView(name: LottieAssetsNames.successfulOrderCreation, loopMode: .playOnce, contentMode: .scaleAspectFill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5,
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.25)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 30) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.orderNumber)))
                                    .font(.ssTitle3)
                                Text(orderCreationViewModel.createdOrder?.id ?? "")
                                    .font(.ssCallout)
                                    .foregroundColor(.accentColor)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            if orderCreationViewModel.orderPayed {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.expectedDeliveryDate)))
                                        .font(.ssTitle3)
                                    Text(orderCreationViewModel.createdOrder?.estimatedDeliveryDate.dateString() ?? "")
                                        .font(.ssCallout)
                                        .foregroundColor(.accentColor)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                }
                                .transition(.move(edge: .leading))
                                .animation(.default)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Button {
                            orderCreationViewModel.shouldPresentStripePaymentSheet = true
                        } label: {
                            Text(TexterifyManager.localisedString(key: orderCreationViewModel.orderPayed ?
                                .orderCreationCompletionView(.payButtonPayedLabel) : .orderCreationCompletionView(.payButton)))
                        }
                        .buttonStyle(CustomButton())
                        .disabled(orderCreationViewModel.orderPayed)
                        
                        Button {
                            withAnimation {
                                cartViewModel.removeAllProductsFromCart()
                                cartViewModel.shouldPresentCheckoutFirstView = false
                            }
                        } label: {
                            Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.completeButton)))
                                .font(.ssButton)
                        }
                        .if(orderCreationViewModel.orderPayed) {
                            $0
                                .buttonStyle(CustomButton())
                        }
                        .if(!orderCreationViewModel.orderPayed) {
                            $0
                                .buttonStyle(CustomButton(textColor: .accentColor,
                                                          onlyStroke: true))
                        }
                        
                        Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.completeWarning)))
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                    }
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .navigationTitle(TexterifyManager.localisedString(key: .orderCreationCompletionView(.navigationTitle)))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .paymentSheet(isPresented: $orderCreationViewModel.shouldPresentStripePaymentSheet,
                          paymentSheet: stripeViewModel.paymentSheet!) { result in
                switch result {
                case .completed:
                    orderCreationViewModel.orderPayed = true
                    guard let profileID = profileViewModel.profile?.id,
                          let orderID = orderCreationViewModel.createdOrder?.id,
                          let currency = LocaleManager.client.clientCurrencyCode else { return }
                    
                    stripeViewModel.updateOrderDataAfterSuccessfulPayment(profileID: profileID,
                                                                          orderID: orderID,
                                                                          currency: currency) { _ in }
                case .canceled:
                    errorManager.generateCustomError(errorType: .paymentCanceledError)
                case .failed(let error):
                    errorManager.generateCustomError(errorType: .paymentFailedError,
                                                     additionalErrorDescription: error.localizedDescription)
                }
            }
        }
    }
}

struct OrderCreationCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let orderCreationViewModel = OrderCreationViewModel()
        let stripeViewModel = StripeViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationCompletionView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(orderCreationViewModel)
                    .environmentObject(stripeViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        orderCreationViewModel.createdOrder = Order.demoOrders[0]
                    }
            }
        }
    }
}
