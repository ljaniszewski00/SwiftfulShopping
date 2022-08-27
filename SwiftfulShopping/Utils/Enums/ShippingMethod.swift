//
//  ShippingMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

enum ShippingMethod: String {
    case pickup = "Pickup"
    case parcel = "Parcel Locker"
    case courier = "Courier"
}

extension ShippingMethod: CaseIterable {
    static var allCases: [ShippingMethod] {
        return [.pickup, .parcel, .courier]
    }
}
