//
//  Discount.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/09/2022.
//

import Foundation

struct Discount {
    var id: String = UUID().uuidString
    var discountCode: String
    var discountValuePercent: Double
    var redeemed: Bool = false
    var redemptionDate: Date? = nil
    var redeemedByUserID: String? = nil
    
    init(discountCode: String, discountValuePercent: Double) {
        self.discountCode = discountCode
        self.discountValuePercent = discountValuePercent
    }
    
    mutating func redeemDiscount(userID: String) {
        self.redeemed = true
        self.redemptionDate = Date()
        self.redeemedByUserID = userID
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
        if redeemed {
            return "\(id)\nDiscount Code: \(discountCode)\nDiscountValue (Percent): \(discountValuePercent)"
        } else {
            return "\(id)\nDiscount Code: \(discountCode)\nDiscountValue (Percent: \(discountValuePercent)\nRedeemed: Yes\nRedemption Date: \(String(describing: redemptionDate))\nRedeemed By UserID: \(redeemedByUserID ?? "")"
        }
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
