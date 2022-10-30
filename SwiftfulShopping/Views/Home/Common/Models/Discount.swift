//
//  Discount.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/09/2022.
//

import Foundation

struct Discount {
    var id: String
    var productID: String
    var discountCode: String
    var discountValuePercent: Double
    var redeemedByUsersIDs: [String] = []
    var redemptionNumber: Int = 0
    var maxRedemptionNumber: Int = 1
    
    init(id: String = UUID().uuidString,
         productID: String,
         discountCode: String,
         discountValuePercent: Double) {
        self.id = id
        self.productID = productID
        self.discountCode = discountCode
        self.discountValuePercent = discountValuePercent
    }
    
    init(id: String,
         productID: String,
         discountCode: String,
         discountValuePercent: Double,
         redeemedByUsersIDs: [String],
         redemptionNumber: Int,
         maxRedemptionNumber: Int) {
        self.id = id
        self.productID = productID
        self.discountCode = discountCode
        self.discountValuePercent = discountValuePercent
        self.redeemedByUsersIDs = redeemedByUsersIDs
        self.redemptionNumber = redemptionNumber
        self.maxRedemptionNumber = maxRedemptionNumber
    }
}

extension Discount: Equatable, Hashable {
    static func == (lhs: Discount, rhs: Discount) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Discount: CustomStringConvertible {
    var description: String {
        return "\(id)\nDiscount Code: \(discountCode)\nDiscountValue (Percent: \(discountValuePercent)\nRedeemed: Yes\n\nRedeemed By UsersIDs: \(redeemedByUsersIDs)"
    }
}

extension Discount {
    static let demoDiscounts: [Discount] = [Discount(id: "w2GWLDm8sE2kuNqJhOy0",
                                                     productID: "LQHU7yJplIXugoPiLucR",
                                                     discountCode: "discount1",
                                                     discountValuePercent: 10),
                                            Discount(id: "TGdggTmagHIkhLSv20Gp",
                                                     productID: "mdQsy0eqYaSiKp6z393S",
                                                     discountCode: "discount2",
                                                     discountValuePercent: 25),
                                            Discount(id: "Bo23pbI15tHlqKk6evmC",
                                                     productID: "BJll5oJjsBoq0tb6Ad8v",
                                                     discountCode: "discount3",
                                                     discountValuePercent: 37),
                                            Discount(id: "w3xRszG9xBUhvk8fLye9",
                                                     productID: "v8yFH9voUUbMvYDXMX4o",
                                                     discountCode: "discount4",
                                                     discountValuePercent: 42),
                                            Discount(id: "MSnu1k1Fz0VtV7CDEIwJ",
                                                     productID: "uMIJzBU5wcwwfUMqsJ2C",
                                                     discountCode: "discount5",
                                                     discountValuePercent: 51)]
}
