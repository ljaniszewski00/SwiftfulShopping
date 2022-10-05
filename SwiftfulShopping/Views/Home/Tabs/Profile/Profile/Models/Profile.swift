//
//  Profile.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Profile {
    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String
    var username: String
    var birthDate: Date
    var email: String
    var country: Countries = .poland
    var defaultAddress: Address
    var addresses: [Address] = []
    var defaultShippingMethod: ShippingMethod = .courier
    var defaultPaymentMethod: PaymentMethod = .creditCard
    var creditCard: CreditCard?
    var userProductsRatings: [String: Int] = [:]
    var userProductsReviews: [String: String] = [:]
    var imageURL: String?
}

extension Profile: CustomStringConvertible {
    var description: String {
        return "\(firstName) \(lastName)\n\(username)\n\(email)"
    }
}

extension Profile {
    static let demoProfile = Profile(firstName: "Jan",
                                     lastName: "Kowalski",
                                     username: "jan.kowalski",
                                     birthDate: Date(),
                                     email: "jan.kowalski@email.com",
                                     defaultAddress: Address.demoAddress,
                                     addresses: [Address.demoAddress,
                                                 Address.otherAddresses[0],
                                                 Address.otherAddresses[1]],
                                     userProductsRatings: [Product.demoProducts[0].id: 3,
                                                           Product.demoProducts[1].id: 1,
                                                           Product.demoProducts[2].id: 5,
                                                           Product.demoProducts[3].id: 5,
                                                           Product.demoProducts[4].id: 2],
                                     imageURL: "")
    
    mutating func addRatingFor(productID: String, rating: Int, review: String?) {
        userProductsRatings[productID] = rating
        if let review = review {
            userProductsReviews[productID] = review
        }
    }
}
