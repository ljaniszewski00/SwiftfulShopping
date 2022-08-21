//
//  PaymentDetailsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import Foundation

class PaymentDetailsViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var cardHolderName: String = ""
    @Published var newDate: Date = Date()
    
    var validThruDate: String {
        newDate.dateString()
    }
    
    @Published var editingCardData: Bool = false
    
    let pickerDateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1))!
        let endDate = Date()
        return startDate...endDate
    }()
    
    var cardCompany: CardCompany {
        detectCardCompany(cardNumber: cardNumber)
    }
    
    var newCardInfoNotValidated: Bool {
        cardNumber.isEmpty ||
        validThruDate.isEmpty ||
        cardHolderName.isEmpty ||
        ![15, 16, 18, 19].contains(cardNumber.count) ||
        validThruDate.count != 5
    }
    
    func initializeDataForNoCard() {
        cardNumber = "XXXX XXXX XXXX XXXX"
        cardHolderName = "John Smith"
    }
    
    func createNewCard() -> CreditCard {
        CreditCard(cardNumber: cardNumber,
                   validThru: validThruDate,
                   cardholderName: cardHolderName)
    }
}
