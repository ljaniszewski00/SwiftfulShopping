//
//  Discount.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/09/2022.
//

import Foundation

struct Discount {
    var id: String = UUID().uuidString
    var productID: String
    var discountCode: String
    var discountValuePercent: Double
    var redeemedByUsersIDs: [String] = []
    var redemptionNumber: Int = 0
    var maxRedemptionNumber: Int = 1
    
    init(productID: String = Product.demoProducts[0].id, discountCode: String, discountValuePercent: Double) {
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
    static let demoDiscounts: [Discount] = [Discount(discountCode: "discount1",
                                                     discountValuePercent: 10),
                                            Discount(discountCode: "discount2",
                                                     discountValuePercent: 25),
                                            Discount(discountCode: "discount3",
                                                     discountValuePercent: 37),
                                            Discount(discountCode: "discount4",
                                                     discountValuePercent: 42),
                                            Discount(discountCode: "discount5",
                                                     discountValuePercent: 51)]
}
