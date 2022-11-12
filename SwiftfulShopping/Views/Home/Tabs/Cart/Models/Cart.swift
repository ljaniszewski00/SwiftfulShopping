//
//  Cart.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Cart {
    var id: String = UUID().uuidString
    var clientID: String
    var orderID: String
    var cartName: String = "Default"
    var productsIDsWithQuantity: [String: Int] = [:]
    var appliedDiscountsIDs: [String] = []
    var totalCost: Double = 0.0
    var totalCostWithAppliedDiscounts: Double = 0.0
    
    init(clientID: String, orderID: String) {
        self.clientID = clientID
        self.orderID = orderID
    }
    
    init(id: String = UUID().uuidString,
         clientID: String,
         orderID: String,
         cartName: String,
         productsIDsWithQuantity: [String: Int],
         appliedDiscountsIDs: [String],
         totalCost: Double,
         totalCostWithAppliedDiscounts: Double) {
        self.id = id
        self.clientID = clientID
        self.orderID = orderID
        self.cartName = cartName
        self.productsIDsWithQuantity = productsIDsWithQuantity
        self.appliedDiscountsIDs = appliedDiscountsIDs
        self.totalCost = totalCost
        self.totalCostWithAppliedDiscounts = totalCostWithAppliedDiscounts
    }
}

extension Cart: Equatable, Hashable {
    static func == (lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Cart: CustomStringConvertible {
    var description: String {
        "\(id)\nClientID: \(clientID)\nOrderID: \(orderID)\nCart Name: \(cartName)\nProductsIDsWithQuantity: \(productsIDsWithQuantity)\nAppliedDiscountsIDs: \(appliedDiscountsIDs)\nTotalCost: \(totalCost)\nTotalCostWithAppliedDiscounts: \(totalCostWithAppliedDiscounts)"
    }
}

extension Cart {
    static let demoCarts = [Cart(id: "0tw4EIfTZuc9TWohXk6K",
                                 clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                 orderID: "3DJOQ3Y0ydl2nrQn83qT",
                                 cartName: "Cart for order NO. 3DJOQ3Y0ydl2nrQn83qT",
                                 productsIDsWithQuantity: Order.demoOrders[0].productsIDsWithQuantity,
                                 appliedDiscountsIDs: [Discount.demoDiscounts.filter { $0.productID == Array(Order.demoOrders[0].productsIDsWithQuantity.keys)[0] }.first?.id ?? ""],
                                 totalCost: Product.demoProducts.filter { Array(Order.demoOrders[0].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +),
                                 totalCostWithAppliedDiscounts: Product.demoProducts.filter { Array(Order.demoOrders[0].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +)),
                            
                            Cart(id: "yCsFjrUwTYNRCL4ASDxi",
                                 clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                 orderID: "qCWd2IGNcfg4x5iPCOt7",
                                 cartName: "Cart for order NO. qCWd2IGNcfg4x5iPCOt7",
                                 productsIDsWithQuantity: Order.demoOrders[1].productsIDsWithQuantity,
                                 appliedDiscountsIDs: [Discount.demoDiscounts.filter { $0.productID == Array(Order.demoOrders[1].productsIDsWithQuantity.keys)[0] }.first?.id ?? ""],
                                 totalCost: Product.demoProducts.filter { Array(Order.demoOrders[0].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +),
                                 totalCostWithAppliedDiscounts: Product.demoProducts.filter { Array(Order.demoOrders[1].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +)),
                            
                            Cart(id: "G1H6F4yf6VIQtA2blgOS",
                                 clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                 orderID: "83vfivSP7G0qCZa8M7Np",
                                 cartName: "Cart for order NO. 83vfivSP7G0qCZa8M7Np",
                                 productsIDsWithQuantity: Order.demoOrders[2].productsIDsWithQuantity,
                                 appliedDiscountsIDs: [Discount.demoDiscounts.filter { $0.productID == Array(Order.demoOrders[2].productsIDsWithQuantity.keys)[0] }.first?.id ?? ""],
                                 totalCost: Product.demoProducts.filter { Array(Order.demoOrders[0].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +),
                                 totalCostWithAppliedDiscounts: Product.demoProducts.filter { Array(Order.demoOrders[2].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +)),
                            
                            Cart(id: "U1AbH8RJdV8ZG6kI1H05",
                                 clientID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                 orderID: "SHCgKcF7miPTYInES9YF",
                                 cartName: "Cart for order NO. SHCgKcF7miPTYInES9YF",
                                 productsIDsWithQuantity: Order.demoOrders[3].productsIDsWithQuantity,
                                 appliedDiscountsIDs: [Discount.demoDiscounts.filter { $0.productID == Array(Order.demoOrders[3].productsIDsWithQuantity.keys)[0] }.first?.id ?? ""],
                                 totalCost: Product.demoProducts.filter { Array(Order.demoOrders[0].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +),
                                 totalCostWithAppliedDiscounts: Product.demoProducts.filter { Array(Order.demoOrders[3].productsIDsWithQuantity.keys).contains($0.id) }.map { $0.price ?? 0 }.reduce(0, +))]
}
