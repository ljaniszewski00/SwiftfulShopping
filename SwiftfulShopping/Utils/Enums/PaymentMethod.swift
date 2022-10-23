//
//  PaymentMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

enum PaymentMethod: String, Codable {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case applePay = "Apple Pay"
}

extension PaymentMethod: CaseIterable {
    static var allCases: [PaymentMethod] {
        return [.cash, .creditCard, .applePay]
    }
}

extension PaymentMethod {
    static func withLabel(_ label: String) -> PaymentMethod? {
        return self.allCases.first { "\($0.rawValue)" == label }
    }
}
