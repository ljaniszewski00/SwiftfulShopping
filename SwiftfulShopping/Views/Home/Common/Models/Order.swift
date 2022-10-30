//
//  Order.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Order {
    var id: String
    var orderDate: Date = Date()
    var estimatedDeliveryDate: Date
    var clientID: String
    var clientDescription: String
    var addressDescription: String
    var shoppingCartID: String
    var productsIDs: [String]
    var shippingMethod: ShippingMethod
    var shippingAddressID: String
    var paymentMethod: PaymentMethod = .creditCard
    var invoice: Bool
    var totalCost: Double = 0.0
    var status: OrderStatus = .placed
    
    init(id: String,
         orderDate: Date,
         estimatedDeliveryDate: Date,
         clientID: String,
         clientDescription: String,
         addressDescription: String,
         shoppingCartID: String,
         productsIDs: [String],
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
        self.clientDescription = clientDescription
        self.addressDescription = addressDescription
        self.shoppingCartID = shoppingCartID
        self.productsIDs = productsIDs
        self.shippingMethod = shippingMethod
        self.shippingAddressID = shippingAddressID
        self.paymentMethod = paymentMethod
        self.invoice = invoice
        self.totalCost = totalCost
        self.status = status
    }
    
    init(id: String = UUID().uuidString,
         clientID: String,
         clientDescription: String,
         addressDescription: String,
         shoppingCartID: String,
         productsIDs: [String],
         shippingMethod: ShippingMethod,
         shippingAddressID: String,
         paymentMethod: PaymentMethod = .creditCard,
         invoice: Bool = false) {
        self.id = id
        self.clientID = clientID
        self.clientDescription = clientDescription
        self.addressDescription = addressDescription
        self.shoppingCartID = shoppingCartID
        self.productsIDs = productsIDs
        self.shippingMethod = shippingMethod
        self.shippingAddressID = shippingAddressID
        self.paymentMethod = paymentMethod
        self.invoice = invoice
        
        self.estimatedDeliveryDate = calculateEstimatedDeliveryDate(orderDate: Date())
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
    static let demoOrders: [Order] = [Order(id: "3DJOQ3Y0ydl2nrQn83qT",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            shoppingCartID: "0tw4EIfTZuc9TWohXk6K",
                                            productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S"],
                                            shippingMethod: .pickup,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2"),
                                      Order(id: "qCWd2IGNcfg4x5iPCOt7",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            shoppingCartID: "yCsFjrUwTYNRCL4ASDxi",
                                            productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S", "BJll5oJjsBoq0tb6Ad8v", "v8yFH9voUUbMvYDXMX4o"],
                                            shippingMethod: .pickup,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2"),
                                      Order(id: "83vfivSP7G0qCZa8M7Np",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            shoppingCartID: "G1H6F4yf6VIQtA2blgOS",
                                            productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S", "BJll5oJjsBoq0tb6Ad8v", "v8yFH9voUUbMvYDXMX4o", "uMIJzBU5wcwwfUMqsJ2C", "IpD65nz0vKKgOUAzVDtq"],
                                            shippingMethod: .pickup,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2"),
                                      Order(id: "SHCgKcF7miPTYInES9YF",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            shoppingCartID: "U1AbH8RJdV8ZG6kI1H05",
                                            productsIDs: ["LQHU7yJplIXugoPiLucR", "mdQsy0eqYaSiKp6z393S", "BJll5oJjsBoq0tb6Ad8v", "v8yFH9voUUbMvYDXMX4o", "uMIJzBU5wcwwfUMqsJ2C", "IpD65nz0vKKgOUAzVDtq", "qxfRHQx4eQF748wBPN7B", "veArtsZlHvLVmJgB1Eb2"],
                                            shippingMethod: .pickup,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2")]
}
