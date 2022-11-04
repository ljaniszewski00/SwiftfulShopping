//
//  PaymentMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation
import texterify_ios_sdk

enum PaymentMethod: String, Codable {
    case cash
    case creditCard
    case applePay
    
    var rawValue: String {
        switch self {
        case .cash:
            return TexterifyManager.localisedString(key: .paymentMethod(.cash))
        case .creditCard:
            return TexterifyManager.localisedString(key: .paymentMethod(.creditCard))
        case .applePay:
            return TexterifyManager.localisedString(key: .paymentMethod(.applePay))
        }
    }
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
