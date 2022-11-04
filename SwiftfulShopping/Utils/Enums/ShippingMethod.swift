//
//  ShippingMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation
import texterify_ios_sdk

enum ShippingMethod: String, Codable {
    case pickup
    case parcel
    case courier
    
    var rawValue: String {
        switch self {
        case .pickup:
            return TexterifyManager.localisedString(key: .shippingMethod(.pickup))
        case .parcel:
            return TexterifyManager.localisedString(key: .shippingMethod(.parcel))
        case .courier:
            return TexterifyManager.localisedString(key: .shippingMethod(.courier))
        }
    }
}

extension ShippingMethod: CaseIterable {
    static var allCases: [ShippingMethod] {
        return [.pickup, .parcel, .courier]
    }
}

extension ShippingMethod {
    static func withLabel(_ label: String) -> ShippingMethod? {
        return self.allCases.first { "\($0.rawValue)" == label }
    }
}
