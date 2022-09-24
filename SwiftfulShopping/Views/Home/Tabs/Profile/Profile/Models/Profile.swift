//
//  Profile.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

struct Profile: Codable {
    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String
    var username: String
    var birthDate: Date
    var email: String
    var defaultAddress: Address
    var addresses: [Address] = []
    var defaultShippingMethod: ShippingMethod = .courier
    var defaultPaymentMethod: PaymentMethod = .creditCard
    var creditCard: CreditCard?
    var userProductsRatings: [String: Int] = [:]
    var userProductsReviews: [String: String] = [:]
    var imageURL: String?
    
    init(firstName: String, lastName: String, username: String, birthDate: Date, email: String, defaultAddress: Address, addresses: [Address], defaultShippingMethod: ShippingMethod = .courier, defaultPaymentMethod: PaymentMethod = .creditCard, creditCard: CreditCard? = nil, userProductsRatings: [String: Int] = [:], userProductsReviews: [String: String] = [:], imageURL: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.birthDate = birthDate
        self.email = email
        self.defaultAddress = defaultAddress
        self.addresses = addresses
        self.defaultShippingMethod = defaultShippingMethod
        self.defaultPaymentMethod = defaultPaymentMethod
        self.creditCard = creditCard
        self.userProductsRatings = userProductsRatings
        self.userProductsReviews = userProductsReviews
        self.imageURL = imageURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case username
        case birthDate
        case email
        case defaultShippingMethod
        case defaultPaymentMethod
        case imageURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        username = try container.decode(String.self, forKey: .username)
        birthDate = try container.decode(Date.self, forKey: .birthDate)
        email = try container.decode(String.self, forKey: .email)
        defaultShippingMethod = try container.decode(ShippingMethod.self, forKey: .defaultShippingMethod)
        defaultPaymentMethod = try container.decode(PaymentMethod.self, forKey: .defaultPaymentMethod)
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(username, forKey: .username)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(email, forKey: .email)
        try container.encode(defaultShippingMethod.rawValue, forKey: .defaultShippingMethod)
        try container.encode(defaultPaymentMethod.rawValue, forKey: .defaultPaymentMethod)
        try container.encode(imageURL, forKey: .imageURL)
    }
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
