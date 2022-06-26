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
    var products: [Product]
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

enum ReturnStatus: String {
    case reported = "Reported"
    case sent = "Sent"
    case delivered = "Delivered"
    case moneyReturned = "Money returned"
    case closed = "Closed"
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
                                               products: Product.demoProducts,
                                               returnPrice: Order.demoOrders[0].totalCost,
                                               returnMethod: Order.demoOrders[0].shippingMethod,
                                               status: .reported),
                                        Return(id: UUID().uuidString,
                                               returnDate: Date(),
                                               clientID: Profile.demoProfile.id,
                                               orderID: Order.demoOrders[1].id,
                                               products: Product.demoProducts,
                                               returnPrice: Order.demoOrders[1].totalCost,
                                               returnMethod: Order.demoOrders[1].shippingMethod,
                                               status: .reported)]
}
