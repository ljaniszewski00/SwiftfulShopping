//
//  Profile.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Profile {
    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String
    var username: String
    var birthDate: Date
    var email: String
    var address: Address
    var otherAddresses: [Address] = []
    var defaultPaymentMethod: PaymentMethod = .creditCard
    var creditCard: CreditCard? = nil
    var imageURL: String? = nil
}

extension Profile: CustomStringConvertible {
    var description: String {
        return "\(firstName) \(lastName)\n\(username)\n\(email)"
    }
}

extension Profile {
    static let demoProfile = Profile(firstName: "Jan",
                                     lastName: "Kowalski",
                                     username: "jan.kowalski",
                                     birthDate: Date(),
                                     email: "jan.kowalski@email.com",
                                     address: Address.demoAddress,
                                     otherAddresses: [Address.otherAddresses[0], Address.otherAddresses[1]],
                                     imageURL: "")
}
