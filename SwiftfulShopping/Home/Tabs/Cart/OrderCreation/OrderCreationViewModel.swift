//
//  OrderCreationViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import Foundation

class OrderCreationViewModel: ObservableObject {
    @Published var choosenAddress: Address?
    @Published var choosenPaymentMethod: PaymentMethod?
    @Published var toReceiveInvoice: Bool = false
    
    @Published var shouldPresentOrderCreationSummaryView: Bool = false
    @Published var shouldPresentOrderCreationCompletionView: Bool = false
    
    var cannotProceedToSummaryView: Bool {
        choosenAddress == nil || choosenPaymentMethod == nil
    }
}
