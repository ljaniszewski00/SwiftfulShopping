//
//  PaymentDetailsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import Foundation

class PaymentDetailsViewModel: ObservableObject {
    @Published var newCardNumber: String = ""
    @Published var newValidThruDate: String = ""
    @Published var newCardholderName: String = ""
    
    var cardCompany: CardCompany {
        detectCardCompany(cardNumber: newCardNumber)
    }
    
    var newCardInfoNotValidated: Bool {
        newCardNumber.isEmpty ||
        newValidThruDate.isEmpty ||
        newCardholderName.isEmpty ||
        ![15, 16, 18, 19].contains(newCardNumber.count) ||
        newValidThruDate.count != 5
    }
    
    func initializeDataForNoCard() {
        newCardNumber = "XXXX XXXX XXXX XXXX"
        newValidThruDate = "mm/YY"
        newCardholderName = "John Smith"
    }
    
    func createNewCard() -> CreditCard {
        CreditCard(cardNumber: newCardNumber,
                   validThru: newValidThruDate,
                   cardholderName: newCardholderName)
    }
}
