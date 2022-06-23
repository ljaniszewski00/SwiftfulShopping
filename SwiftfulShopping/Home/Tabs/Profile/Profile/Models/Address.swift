//
//  Address.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Address {
    var streetName: String
    var streetNumber: String
    var apartmentNumber: String
    var zipCode: String
    var city: String
    var country: String
}

extension Address {
    static let demoAddress: Address = Address(streetName: "Wierzbowskiego",
                                              streetNumber: "13",
                                              apartmentNumber: "26",
                                              zipCode: "23-123",
                                              city: "New York",
                                              country: "United States")
}
