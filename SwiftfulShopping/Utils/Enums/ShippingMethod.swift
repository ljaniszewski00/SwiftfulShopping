//
//  ShippingMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

enum ShippingMethod: String, Codable {
    case pickup = "Pickup"
    case parcel = "Parcel Locker"
    case courier = "Courier"
}

extension ShippingMethod: CaseIterable {
    static var allCases: [ShippingMethod] {
        return [.pickup, .parcel, .courier]
    }
}

extension ShippingMethod {
    static func withLabel(_ label: String) -> ShippingMethod? {
        return self.allCases.first { "\($0)" == label }
    }
}
