//
//  Profile.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Profile {
    var id: String
    var fullName: String
    var username: String?
    var birthDate: Date?
    var email: String?
    var country: Countries = .poland
    var defaultShipmentAddress: Address
    var shipmentAddresses: [Address] = []
    var invoiceAddress: Address
    var defaultShippingMethod: ShippingMethod = .courier
    var defaultPaymentMethod: PaymentMethod = .creditCard
    var creditCard: CreditCard?
    var imageURL: String?
    var createdWith: SignInMethod?
}

extension Profile: CustomStringConvertible {
    var description: String {
        return "\(fullName)\n\(username)\n\(email)"
    }
}

extension Profile {
    static let demoProfile = Profile(id: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                     fullName: "Jan Kowalski",
                                     username: "jan.kowalski",
                                     birthDate: Date(),
                                     email: "jan.kowalski@email.com",
                                     defaultShipmentAddress: Address.demoAddress,
                                     shipmentAddresses: [Address.demoAddress,
                                                         Address.otherAddresses[0],
                                                         Address.otherAddresses[1]],
                                     invoiceAddress: Address.demoAddress,
                                     imageURL: "")
}
