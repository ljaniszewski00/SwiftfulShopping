//
//  StripePaymentView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/11/2022.
//

import SwiftUI
import StripePaymentSheet
import Inject

struct StripePaymentView: View {
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    @StateObject private var stripeViewModel: StripeViewModel = StripeViewModel()
    
    var body: some View {
        VStack {
            if let paymentSheet = stripeViewModel.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: stripeViewModel.onPaymentCompletion
                ) {
                    Text("Buy")
                }
            } else {
                Text("Loading…")
            }
            if let result = stripeViewModel.paymentResult {
                switch result {
                case .completed:
                    Text("Payment complete")
                        .onAppear {
                            orderCreationViewModel.shouldPresentStripePaymentView = false
                            orderCreationViewModel.orderPayed = true
                        }
                case .failed(let error):
                    Text("Payment failed: \(error.localizedDescription)")
                case .canceled:
                    Text("Payment canceled.")
                }
            }
        }
        .onAppear {
            stripeViewModel.preparePaymentSheet()
        }
        .enableInjection()
    }
}

struct StripePaymentView_Previews: PreviewProvider {
    static var previews: some View {
        let orderCreationViewModel: OrderCreationViewModel = OrderCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                StripePaymentView()
                    .environmentObject(orderCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
