//
//  CreditCard.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import Foundation

struct CreditCard {
    var id: String = UUID().uuidString
    var company: CardCompany
    var cardNumber: String
    var validThru: String
    var cardholderName: String
    
    init(cardNumber: String, validThru: String, cardholderName: String) {
        self.cardNumber = cardNumber
        self.validThru = validThru
        self.cardholderName = cardholderName
        
        self.company = detectCardCompany(cardNumber: cardNumber)
    }
}

extension CreditCard: CustomStringConvertible {
    var description: String {
        return "\(company.rawValue)\n\(cardNumber)\n\(validThru)\n\(cardholderName)"
    }
}

extension Profile {
    static let demoCard = CreditCard(cardNumber: "5321 1234 1242 6432",
                                     validThru: "03/24",
                                     cardholderName: Profile.demoProfile.firstName + Profile.demoProfile.lastName)
}
