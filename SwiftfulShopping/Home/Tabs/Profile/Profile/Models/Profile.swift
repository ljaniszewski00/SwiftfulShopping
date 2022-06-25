//
//  Profile.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Profile {
    var id: String
    var firstName: String
    var lastName: String
    var username: String
    var birthDate: Date
    var email: String
    var address: Address
    var imageURL: String? = nil
}

extension Profile: CustomStringConvertible {
    var description: String {
        return "\(firstName) \(lastName)\n\(username)\n\(email)"
    }
}

extension Profile {
    static let demoProfile = Profile(id: UUID().uuidString,
                                     firstName: "Jan",
                                     lastName: "Kowalski",
                                     username: "jan.kowalski",
                                     birthDate: Date(),
                                     email: "jan.kowalski@email.com",
                                     address: Address.demoAddress,
                                     imageURL: "dd")
}
