//
//  Return.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Return {
    var id: String = UUID().uuidString
    var returnDate: Date = Date()
    var clientID: String
    var orderID: String
    var productsIDs: [String]
    var returnPrice: Double
    var returnMethod: ShippingMethod
    var status: ReturnStatus = .reported
    
    var bankAccountNumber: String = ""
    var bankAccountOwnerName: String = ""
    var bankAccountOwnerStreetAndHouseNumber: String = ""
    var bankAccountOwnerPostalCode: String = ""
    var bankAccountOwnerCity: String = ""
    var bankAccountOwnerCountry: String = ""
}

extension Return: Equatable, Hashable {
    static func == (lhs: Return, rhs: Return) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Return: CustomStringConvertible {
    var description: String {
        "\(id)\nReturn Date: \(Date.getDayMonthYearFrom(date: returnDate))\nClient ID: \(clientID)\nOrder ID: \(orderID)\nReturn Price: \(returnPrice)\nReturn Method: \(returnMethod.rawValue)\nStatus: \(status.rawValue)"
    }
}

extension Return {
    static let demoReturns: [Return] = [Return(id: "MvtxU2Yzw3fxKbWLWM9K",
                                               returnDate: Date(),
                                               clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                               orderID: "3DJOQ3Y0ydl2nrQn83qT",
                                               productsIDs: ["LQHU7yJplIXugoPiLucR"],
                                               returnPrice: 799.99,
                                               returnMethod: Order.demoOrders[0].shippingMethod,
                                               status: .reported),
                                        Return(id: "AqCXYgPJtxYE9PWpDltD",
                                               returnDate: Date(),
                                               clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                               orderID: "qCWd2IGNcfg4x5iPCOt7",
                                               productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S"],
                                               returnPrice: 1399.98,
                                               returnMethod: Order.demoOrders[1].shippingMethod,
                                               status: .reported),
                                        Return(id: "mKjcsUz8JHD6lS3Y9fgF",
                                               returnDate: Date(),
                                               clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                               orderID: "83vfivSP7G0qCZa8M7Np",
                                               productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S", "BJll5oJjsBoq0tb6Ad8v"],
                                               returnPrice: 2299.97,
                                               returnMethod: Order.demoOrders[2].shippingMethod,
                                               status: .reported),
                                        Return(id: "TZYZIK3Yu6e3Y8M4ZNj7",
                                               returnDate: Date(),
                                               clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                               orderID: "SHCgKcF7miPTYInES9YF",
                                               productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S", "BJll5oJjsBoq0tb6Ad8v", "v8yFH9voUUbMvYDXMX4o"],
                                               returnPrice: 3299.96,
                                               returnMethod: Order.demoOrders[3].shippingMethod,
                                               status: .reported)]
}
