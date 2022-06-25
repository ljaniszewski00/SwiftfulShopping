//
//  Order.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Order {
    var id: String
    var orderDate: Date
    var estimatedDeliveryDate: Date
    var clientID: String
    var clientInfo: String
    var shoppingCart: Cart
    var shippingMethod: ShippingMethod
    var shippingAddress: String
    var paymentMethod: PaymentMethod = .creditCard
    var totalCost: Double
    var status: OrderStatus
}

enum OrderStatus: String {
    case placed = "Placed"
    case payed = "Payed"
    case picked = "Picked"
    case readyToBeSend = "Ready to be send"
    case sent = "Sent"
    case delivered = "Delivered"
    case closed = "Closed"
}

extension Order: Equatable, Hashable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Order: CustomStringConvertible {
    var description: String {
        "\(id)\nOrder Date: \(Date.getDayMonthYearFrom(date: orderDate))\nEstimated Delivery Date: \(Date.getDayMonthYearFrom(date: estimatedDeliveryDate))\nShipping Method: \(shippingMethod.rawValue)\nPayment Method: \(paymentMethod.rawValue)\nTotal Cost: \(totalCost)\nStatus: \(status)"
    }
}

extension Order {
    static let demoOrders: [Order] = [Order(id: UUID().uuidString,
                                            orderDate: Date().getRandomDate(),
                                            estimatedDeliveryDate: Date(),
                                            clientID: UUID().uuidString,
                                            clientInfo: Profile.demoProfile.description,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .pickup,
                                            shippingAddress: Address.demoAddress.description,
                                            totalCost: 30.30,
                                            status: .placed),
                                      Order(id: UUID().uuidString,
                                            orderDate: Date().getRandomDate(),
                                            estimatedDeliveryDate: Date(),
                                            clientID: UUID().uuidString,
                                            clientInfo: Profile.demoProfile.description,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddress: Address.demoAddress.description,
                                            totalCost: 320.50,
                                            status: .delivered),
                                      Order(id: UUID().uuidString,
                                            orderDate: Date().getRandomDate(),
                                            estimatedDeliveryDate: Date(),
                                            clientID: UUID().uuidString,
                                            clientInfo: Profile.demoProfile.description,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddress: Address.demoAddress.description,
                                            totalCost: 320.50,
                                            status: .delivered),
                                      Order(id: UUID().uuidString,
                                            orderDate: Date().getRandomDate(),
                                            estimatedDeliveryDate: Date(),
                                            clientID: UUID().uuidString,
                                            clientInfo: Profile.demoProfile.description,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddress: Address.demoAddress.description,
                                            totalCost: 320.50,
                                            status: .delivered)]
}
