//
//  Cart.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Cart {
    var id: String = UUID().uuidString
    var clientID: String = Profile.demoProfile.id
    var orderID: String = Order.demoOrders[0].id
    var cartName: String = "Default"
    var productsIDsWithQuantity: [String: Int] = [:]
    var appliedDiscountsIDs: [String] = []
    var totalCost: Double = 0.0
    var totalCostWithAppliedDiscounts: Double = 0.0
    
    init() {}
    
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
    static let demoCart = Cart()
}
