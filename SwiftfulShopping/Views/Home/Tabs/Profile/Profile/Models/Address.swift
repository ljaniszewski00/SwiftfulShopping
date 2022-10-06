//
//  Address.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Address {
    var id: String = UUID().uuidString
    var userID: String
    var fullName: String
    var streetName: String
    var streetNumber: String
    var apartmentNumber: String
    var zipCode: String
    var city: String
    var country: String
    var isDefaultAddress: Bool = false
    var isInvoiceAddress: Bool = false
}

extension Address: CustomStringConvertible {
    var description: String {
        return "\(fullName)\n\(streetName) \(streetNumber)/\(apartmentNumber)\n\(zipCode) \(city)\n\(country)"
    }
}

extension Address: Equatable, Hashable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Address {
    static let demoAddress: Address = Address(userID: UUID().uuidString,
                                              fullName: "John Doe 1",
                                              streetName: "Wierzbowskiego",
                                              streetNumber: "13",
                                              apartmentNumber: "26",
                                              zipCode: "23-123",
                                              city: "New York",
                                              country: "United States")
    
    static let otherAddresses: [Address] = [Address(userID: UUID().uuidString,
                                                    fullName: "John Doe 2",
                                                    streetName: "Więckowskiego",
                                                    streetNumber: "324",
                                                    apartmentNumber: "64",
                                                    zipCode: "23-123",
                                                    city: "New York",
                                                    country: "United States"),
                                            Address(userID: UUID().uuidString,
                                                    fullName: "John Doe 3",
                                                    streetName: "Brzozowa",
                                                    streetNumber: "352",
                                                    apartmentNumber: "67",
                                                    zipCode: "23-123",
                                                    city: "New York",
                                                    country: "United States")]
}
