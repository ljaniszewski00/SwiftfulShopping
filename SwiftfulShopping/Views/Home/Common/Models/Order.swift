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
    var productsIDsWithQuantity: [String: Int]
    var shippingMethod: ShippingMethod
    var shippingAddressID: String
    var paymentMethod: PaymentMethod
    var invoice: Bool
    var productsCost: Double
    var appliedDiscountsCodesWithValue: [String: Double] = [:]
    var shippingCost: Double
    var paymentCost: Double
    var totalCost: Double
    var currency: String
    var payed: Bool
    var paymentID: String?
    var status: OrderStatus = .placed
    
    init(id: String,
         orderDate: Date,
         estimatedDeliveryDate: Date,
         clientID: String,
         clientDescription: String,
         addressDescription: String,
         productsIDsWithQuantity: [String: Int],
         shippingMethod: ShippingMethod,
         shippingAddressID: String,
         paymentMethod: PaymentMethod,
         invoice: Bool,
         productsCost: Double,
         appliedDiscountsCodesWithValue: [String: Double],
         shippingCost: Double,
         paymentCost: Double,
         totalCost: Double,
         currency: String,
         payed: Bool,
         paymentID: String?,
         status: OrderStatus) {
        self.id = id
        self.orderDate = orderDate
        self.estimatedDeliveryDate = estimatedDeliveryDate
        self.clientID = clientID
        self.clientDescription = clientDescription
        self.addressDescription = addressDescription
        self.productsIDsWithQuantity = productsIDsWithQuantity
        self.shippingMethod = shippingMethod
        self.shippingAddressID = shippingAddressID
        self.paymentMethod = paymentMethod
        self.invoice = invoice
        self.productsCost = productsCost
        self.appliedDiscountsCodesWithValue = appliedDiscountsCodesWithValue
        self.shippingCost = shippingCost
        self.paymentCost = paymentCost
        self.totalCost = totalCost
        self.currency = currency
        self.payed = payed
        self.paymentID = paymentID
        self.status = status
    }
    
    init(id: String = UUID().uuidString,
         clientID: String,
         clientDescription: String,
         addressDescription: String,
         productsIDsWithQuantity: [String: Int],
         shippingMethod: ShippingMethod,
         shippingAddressID: String,
         paymentMethod: PaymentMethod,
         invoice: Bool = false,
         productsCost: Double,
         appliedDiscountsCodesWithValue: [String: Double],
         shippingCost: Double,
         paymentCost: Double,
         totalCost: Double,
         currency: String,
         payed: Bool,
         paymentID: String?) {
        self.id = id
        self.clientID = clientID
        self.clientDescription = clientDescription
        self.addressDescription = addressDescription
        self.productsIDsWithQuantity = productsIDsWithQuantity
        self.shippingMethod = shippingMethod
        self.shippingAddressID = shippingAddressID
        self.paymentMethod = paymentMethod
        self.invoice = invoice
        self.productsCost = productsCost
        self.appliedDiscountsCodesWithValue = appliedDiscountsCodesWithValue
        self.shippingCost = shippingCost
        self.paymentCost = paymentCost
        self.totalCost = totalCost
        self.currency = currency
        self.payed = payed
        self.paymentID = paymentID
        
        self.estimatedDeliveryDate = calculateEstimatedDeliveryDate(orderDate: Date(), shippingMethod: shippingMethod)
    }
    
    static let shippingMethodsPrices: [ShippingMethod: [String: Double]] = [
        .courier: ["USD": 3.99,
                   "PLN": 16.99,
                   "CZK": 90.99,
                   "EUR": 3.60,
                   "GBP": 3.00],
        .parcel: ["USD": 2.99,
                  "PLN": 11.99,
                  "CZK": 60.99,
                  "EUR": 2.60,
                  "GBP": 2.00]
    ]
    
    static let paymentMethodPrices: [PaymentMethod: [String: Double]] = [
        .cash: ["USD": 0,
                "PLN": 0,
                "CZK": 0,
                "EUR": 0,
                "GBP": 0],
        .creditCard: ["USD": 0,
                      "PLN": 0,
                      "CZK": 0,
                      "EUR": 0,
                      "GBP": 0],
        .applePay: ["USD": 0,
                    "PLN": 0,
                    "CZK": 0,
                    "EUR": 0,
                    "GBP": 0]
    ]
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
                                            productsIDsWithQuantity: ["LQHU7yJplIXugoPiLucR": 1,
                                                                      "mdQsy0eqYaSiKp6z393S": 2],
                                            shippingMethod: .courier,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2",
                                            paymentMethod: .creditCard,
                                            productsCost: 9220.12,
                                            appliedDiscountsCodesWithValue: [:],
                                            shippingCost: shippingMethodsPrices[.courier]?["PLN"] ?? 0,
                                            paymentCost: paymentMethodPrices[.creditCard]?["PLN"] ?? 0,
                                            totalCost: (9220.12 + (shippingMethodsPrices[.courier]?["PLN"] ?? 0) + (paymentMethodPrices[.creditCard]?["PLN"] ?? 0)),
                                            currency: "PLN",
                                            payed: true,
                                            paymentID: ""),
                                      Order(id: "qCWd2IGNcfg4x5iPCOt7",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            productsIDsWithQuantity: ["LQHU7yJplIXugoPiLucR": 1,
                                                                      "mdQsy0eqYaSiKp6z393S": 2,
                                                                      "BJll5oJjsBoq0tb6Ad8v": 3,
                                                                      "v8yFH9voUUbMvYDXMX4o": 4],
                                            shippingMethod: .courier,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2",
                                            paymentMethod: .creditCard,
                                            productsCost: 40107.72,
                                            appliedDiscountsCodesWithValue: [:],
                                            shippingCost: shippingMethodsPrices[.courier]?["PLN"] ?? 0,
                                            paymentCost: paymentMethodPrices[.creditCard]?["PLN"] ?? 0,
                                            totalCost: (40107.72 + (shippingMethodsPrices[.courier]?["PLN"] ?? 0) + (paymentMethodPrices[.creditCard]?["PLN"] ?? 0)),
                                            currency: "PLN",
                                            payed: false,
                                            paymentID: nil),
                                      Order(id: "83vfivSP7G0qCZa8M7Np",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            productsIDsWithQuantity: ["LQHU7yJplIXugoPiLucR": 1,
                                                                      "mdQsy0eqYaSiKp6z393S": 2,
                                                                      "BJll5oJjsBoq0tb6Ad8v": 3,
                                                                      "v8yFH9voUUbMvYDXMX4o": 4,
                                                                      "uMIJzBU5wcwwfUMqsJ2C": 5,
                                                                      "IpD65nz0vKKgOUAzVDtq": 6],
                                            shippingMethod: .courier,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2",
                                            paymentMethod: .creditCard,
                                            productsCost: 116635.55,
                                            appliedDiscountsCodesWithValue: [:],
                                            shippingCost: shippingMethodsPrices[.courier]?["PLN"] ?? 0,
                                            paymentCost: paymentMethodPrices[.creditCard]?["PLN"] ?? 0,
                                            totalCost: (116635.55 + (shippingMethodsPrices[.courier]?["PLN"] ?? 0) + (paymentMethodPrices[.creditCard]?["PLN"] ?? 0)),
                                            currency: "PLN",
                                            payed: true,
                                            paymentID: UUID().uuidString),
                                      Order(id: "SHCgKcF7miPTYInES9YF",
                                            clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                            clientDescription: Profile.demoProfile.description,
                                            addressDescription: Address.demoAddress.description,
                                            productsIDsWithQuantity: ["LQHU7yJplIXugoPiLucR": 1,
                                                                      "mdQsy0eqYaSiKp6z393S": 2,
                                                                      "BJll5oJjsBoq0tb6Ad8v": 3,
                                                                      "v8yFH9voUUbMvYDXMX4o": 4,
                                                                      "uMIJzBU5wcwwfUMqsJ2C": 5,
                                                                      "IpD65nz0vKKgOUAzVDtq": 6,
                                                                      "qxfRHQx4eQF748wBPN7B": 7,
                                                                      "veArtsZlHvLVmJgB1Eb2": 8],
                                            shippingMethod: .courier,
                                            shippingAddressID: "81D3477F-0E53-4DED-B171-2C46FEB733D2",
                                            paymentMethod: .creditCard,
                                            productsCost: 218979.95,
                                            appliedDiscountsCodesWithValue: [:],
                                            shippingCost: shippingMethodsPrices[.courier]?["PLN"] ?? 0,
                                            paymentCost: paymentMethodPrices[.creditCard]?["PLN"] ?? 0,
                                            totalCost: (218979.95 + (shippingMethodsPrices[.courier]?["PLN"] ?? 0) + (paymentMethodPrices[.creditCard]?["PLN"] ?? 0)),
                                            currency: "PLN",
                                            payed: false,
                                            paymentID: nil)]
}
