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
    var clientID: String
    var shoppingCartID: String
    var shippingMethod: ShippingMethod
    var shippingAddressID: String
    var paymentMethod: PaymentMethod = .creditCard
    var invoice: Bool
    var totalCost: Double
    var status: OrderStatus = .placed
    
    init(id: String,
         orderDate: Date,
         estimatedDeliveryDate: Date,
         clientID: String,
         shoppingCartID: String,
         shippingMethod: ShippingMethod,
         shippingAddressID: String,
         paymentMethod: PaymentMethod,
         invoice: Bool,
         totalCost: Double,
         status: OrderStatus) {
        self.id = id
        self.orderDate = orderDate
        self.estimatedDeliveryDate = estimatedDeliveryDate
        self.clientID = clientID
        self.shoppingCartID = shoppingCartID
        self.shippingMethod = shippingMethod
        self.shippingAddressID = shippingAddressID
        self.paymentMethod = paymentMethod
        self.invoice = invoice
        self.totalCost = totalCost
        self.status = status
    }
    
    init(clientID: String,
         shoppingCartID: String,
         shippingMethod: ShippingMethod,
         shippingAddressID: String,
         paymentMethod: PaymentMethod = .creditCard,
         invoice: Bool = false) {
        self.clientID = clientID
        self.shoppingCartID = shoppingCartID
        self.shippingMethod = shippingMethod
        self.shippingAddressID = shippingAddressID
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
    static let demoOrders: [Order] = [Order(clientID: Profile.demoProfile.id,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .pickup,
                                            shippingAddressID: Address.demoAddress.id),
                                      Order(clientID: Profile.demoProfile.id,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddressID: Address.demoAddress.id),
                                      Order(clientID: Profile.demoProfile.id,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddressID: Address.demoAddress.id),
                                      Order(clientID: Profile.demoProfile.id,
                                            shoppingCart: Cart.demoCart,
                                            shippingMethod: .parcel,
                                            shippingAddressID: Address.demoAddress.id)]
}
