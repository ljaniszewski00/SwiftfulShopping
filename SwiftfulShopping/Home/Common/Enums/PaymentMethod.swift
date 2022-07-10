//
//  PaymentMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

enum PaymentMethod: String {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case applePay = "Apple Pay"
}

extension PaymentMethod: CaseIterable {
    static var allCases: [PaymentMethod] {
        return [.cash, .creditCard, .applePay]
    }
}
