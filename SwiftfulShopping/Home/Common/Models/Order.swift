//
//  Order.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Order {
    var id: String = UUID().uuidString
    var orderDate: Date = Date()
    var estimatedDeliveryDate: Date
    var client: Profile
    var shoppingCart: Cart
    var shippingMethod: ShippingMethod
    var shippingAddress: Address
    var paymentMethod: PaymentMethod = .creditCard
    var invoice: Bool
    var totalCost: Double
    var status: OrderStatus = .placed
    
    init(client: Profile, shoppingCart: Cart, shippingMethod: ShippingMethod, shippingAddress: Address, paymentMethod: PaymentMethod = .creditCard, invoice: Bool = false) {
        self.client = client
        self.shoppingCart = shoppingCart
        self.shippingMethod = shippingMethod
        self.shippingAddress = shippingAddress
        self.paymentMethod = paymentMethod
        self.invoice = invoice
        
        self.estimatedDeliveryDate = calculateEstimatedDeliveryDate(orderDate: Date())
        
        self.totalCost = shoppingCart.products.keys.map { $0.price }.reduce(0, +)
    }
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
    static let demoOrders: [Order] = [Order(client: Profile.demoProfile,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .pickup,
                                            shippingAddress: Address.demoAddress),
                                      Order(client: Profile.demoProfile,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddress: Address.demoAddress),
                                      Order(client: Profile.demoProfile,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddress: Address.demoAddress),
                                      Order(client: Profile.demoProfile,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddress: Address.demoAddress)]
}
