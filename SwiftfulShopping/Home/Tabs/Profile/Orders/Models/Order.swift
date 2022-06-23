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
    var shoppingCart: Cart
    var shippingMethod: ShippingMethod
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

extension Order {
    static let demoOrders: [Order] = [Order(id: UUID().uuidString,
                                            orderDate: Date(),
                                            estimatedDeliveryDate: Date(),
                                            clientID: UUID().uuidString,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .pickup,
                                            totalCost: 30.30,
                                            status: .placed),
                                      Order(id: UUID().uuidString,
                                            orderDate: Date(),
                                            estimatedDeliveryDate: Date(),
                                            clientID: UUID().uuidString,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            totalCost: 320.50,
                                            status: .delivered)]
}
