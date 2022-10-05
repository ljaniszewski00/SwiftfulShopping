//
//  FirestoreManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 05/10/2022.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()

    
    private enum DatabaseCollections: String {
        case profiles = "Profiles"
        case addresses = "Addresses"
        case orders = "Orders"
        case discounts = "Discounts"
        case returns = "Returns"
    }
    
    static var client: FirestoreManager = {
        FirestoreManager()
    }()
    
    private init() {}
    
    func getProfiles(completion: @escaping (([Profile]) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching profile data: \(error.localizedDescription)")
            } else {
                let profiles = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Profile in
                    
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["firstName"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let birthDate = data["birthDate"] as? Date ?? Date()
                    let email = data["email"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let defaultAddress = data["defaultAddressID"] as? String ?? ""
                    let addresses = data["addresses"] as? [String] ?? []
                    let defaultShippingMethod = data["defaultShippingMethod"] as? String ?? ""
                    let defaultPaymentMethod = data["defaultPaymentMethod"] as? String ?? ""
                    let userProductsRatings = data["userProductsRatingsIDs"] as? [String] ?? []
                    let userProductsReviews = data["userProductsReviewsIDs"] as? [String] ?? []
                    let imageURL = data["imageURL"] as? String ?? ""
                    
                    return Profile(id: id,
                                   firstName: firstName,
                                   lastName: lastName,
                                   username: username,
                                   birthDate: birthDate,
                                   email: email,
                                   country: Countries.withLabel(country) ?? .poland,
                                   defaultAddress: Address.demoAddress,
                                   addresses: [],
                                   defaultShippingMethod: ShippingMethod.withLabel(defaultShippingMethod) ?? .courier,
                                   defaultPaymentMethod: PaymentMethod.withLabel(defaultPaymentMethod) ?? .creditCard,
                                   userProductsRatings: [:],
                                   userProductsReviews: [:],
                                   imageURL: imageURL)
                    
                }
                
                completion(profiles)
            }
        }
    }
    
    func getAddresses() async throws -> [Address]? {
        nil
    }
    
    func getOrders() async throws -> [Order]? {
        nil
    }
    
    func getDiscounts() async throws -> [Discount]? {
        nil
    }
    
    func getReturns() async throws -> [Return]? {
        nil
    }
}

extension FirestoreManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
