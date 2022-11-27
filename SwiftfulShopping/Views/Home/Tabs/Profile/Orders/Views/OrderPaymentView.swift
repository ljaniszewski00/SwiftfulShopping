//
//  OrderPaymentView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 27/11/2022.
//

import SwiftUI
import StripePaymentSheet
import texterify_ios_sdk

struct OrderPaymentView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var orderDetailsViewModel: OrderDetailsViewModel
    @EnvironmentObject private var stripeViewModel: StripeViewModel
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var errorManager: ErrorManager = ErrorManager.shared
    
    var profileID: String
    var orderID: String
    
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(name: LottieAssetsNames.orderPayment, contentMode: .scaleAspectFill)
                .frame(width: 300, height: 300)
                .offset(y: -100)
            
            Spacer()
            
            Button {
                orderDetailsViewModel.shouldPresentStripePaymentSheet = true
            } label: {
                Text(TexterifyManager.localisedString(key: .orderPaymentView(.payButton)))
            }
            .buttonStyle(CustomButton())
            .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
        }
        .padding()
        .navigationTitle(TexterifyManager.localisedString(key: .orderPaymentView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .modifier(LoadingIndicatorModal(isPresented: $stripeViewModel.showLoadingModal))
        .onAppear {
            orderDetailsViewModel.shouldPresentStripePaymentSheet = true
        }
        .paymentSheet(isPresented: $orderDetailsViewModel.shouldPresentStripePaymentSheet,
                      paymentSheet: stripeViewModel.paymentSheet!) { result in
            guard let currency = orderDetailsViewModel.currencyCode else { return }
                  
            switch result {
            case .completed:
                stripeViewModel.updateOrderDataAfterSuccessfulPayment(profileID: profileID,
                                                                      orderID: orderID,
                                                                      currency: currency) { _ in dismiss() }
            case .canceled:
                errorManager.generateCustomError(errorType: .paymentCanceledError)
            case .failed(let error):
                errorManager.generateCustomError(errorType: .paymentFailedError,
                                                 additionalErrorDescription: error.localizedDescription)
            }
        }
    }
}

struct OrderPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager: TabBarStateManager = TabBarStateManager()
        let orderDetailsViewModel: OrderDetailsViewModel = OrderDetailsViewModel()
        let stripeViewModel: StripeViewModel = StripeViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderPaymentView(profileID: "",
                                 orderID: "")
                    .environmentObject(tabBarStateManager)
                    .environmentObject(orderDetailsViewModel)
                    .environmentObject(stripeViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
