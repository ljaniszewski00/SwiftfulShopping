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
    static let demoReturns: [Return] = [Return(id: UUID().uuidString,
                                               returnDate: Date(),
                                               clientID: Profile.demoProfile.id,
                                               orderID: Order.demoOrders[0].id,
                                               productsIDs: Product.demoProducts.map { $0.id },
                                               returnPrice: Order.demoOrders[0].totalCost,
                                               returnMethod: Order.demoOrders[0].shippingMethod,
                                               status: .reported),
                                        Return(id: UUID().uuidString,
                                               returnDate: Date(),
                                               clientID: Profile.demoProfile.id,
                                               orderID: Order.demoOrders[1].id,
                                               productsIDs: Product.demoProducts.map { $0.id },
                                               returnPrice: Order.demoOrders[1].totalCost,
                                               returnMethod: Order.demoOrders[1].shippingMethod,
                                               status: .reported)]
}
