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
        case shipmentAddresses = "Shipment Addresses"
        case invoiceAddresses = "Invoice Addresses"
        case orders = "Orders"
        case discounts = "Discounts"
        case returns = "Returns"
        case products = "Products"
        case productsRatings = "Products Ratings"
        case productsReviews = "Products Reviews"
    }
    
    static var client: FirestoreManager = {
        FirestoreManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getProfiles(completion: @escaping (([Profile]?) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching profiles data: \(error.localizedDescription)")
            } else {
                let profiles = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Profile in
                    
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let fullName = data["fullName"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let birthDate = data["birthDate"] as? Date ?? Date()
                    let email = data["email"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let defaultShipmentAddress = data["defaultShipmentAddressID"] as? String ?? ""
                    let invoiceAddress = data["invoiceAddressID"] as? String ?? ""
                    let addresses = data["addresses"] as? [String] ?? []
                    let defaultShippingMethod = data["defaultShippingMethod"] as? String ?? ""
                    let defaultPaymentMethod = data["defaultPaymentMethod"] as? String ?? ""
                    let userProductsRatings = data["userProductsRatingsIDs"] as? [String] ?? []
                    let userProductsReviews = data["userProductsReviewsIDs"] as? [String] ?? []
                    let imageURL = data["imageURL"] as? String ?? ""
                    
                    return Profile(id: id,
                                   fullName: fullName,
                                   username: username,
                                   birthDate: birthDate,
                                   email: email,
                                   country: Countries.withLabel(country) ?? .poland,
                                   defaultShipmentAddress: Address.demoAddress,
                                   shipmentAddresses: [Address.demoAddress],
                                   invoiceAddress: Address.demoAddress,
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
    
    func getUserProfile(userID: String, completion: @escaping ((Profile?) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .whereField("id", isEqualTo: userID)
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching profile data: \(error.localizedDescription)")
            } else {
                let profile = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Profile in
                    
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let fullName = data["fullName"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let birthDate = data["birthDate"] as? Date ?? Date()
                    let email = data["email"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let defaultShipmentAddress = data["defaultShipmentAddressID"] as? String ?? ""
                    let shipmentAddresses = data["shipmentAddressesIDs"] as? [String] ?? []
                    let invoiceAddress = data["invoiceAddressID"] as? String ?? ""
                    let defaultShippingMethod = data["defaultShippingMethod"] as? String ?? ""
                    let defaultPaymentMethod = data["defaultPaymentMethod"] as? String ?? ""
                    let userProductsRatings = data["userProductsRatingsIDs"] as? [String] ?? []
                    let userProductsReviews = data["userProductsReviewsIDs"] as? [String] ?? []
                    let imageURL = data["imageURL"] as? String ?? ""
                    
                    return Profile(id: id,
                                   fullName: fullName,
                                   username: username,
                                   birthDate: birthDate,
                                   email: email,
                                   country: Countries.withLabel(country) ?? .poland,
                                   defaultShipmentAddress: Address.demoAddress,
                                   shipmentAddresses: [Address.demoAddress],
                                   invoiceAddress: Address.demoAddress,
                                   defaultShippingMethod: ShippingMethod.withLabel(defaultShippingMethod) ?? .courier,
                                   defaultPaymentMethod: PaymentMethod.withLabel(defaultPaymentMethod) ?? .creditCard,
                                   userProductsRatings: [:],
                                   userProductsReviews: [:],
                                   imageURL: imageURL)
                    
                }
                    .first
                
                completion(profile)
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
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func createProfile(profile: Profile, completion: @escaping ((Bool, Error?) -> ())) {
        let profileDocumentData: [String: Any] = [
            "id": profile.id,
            "fullName": profile.fullName,
            "username": profile.username,
            "birthDate": profile.birthDate,
            "email": profile.email,
            "country": profile.country.rawValue,
            "defaultShipmentAddressID": profile.defaultShipmentAddress.id,
            "shipmentAddressesIDs": [profile.defaultShipmentAddress.id],
            "invoiceAddressID": profile.invoiceAddress.id,
            "defaultShippingMethod": ShippingMethod.courier.rawValue,
            "defaultPaymentMethod": PaymentMethod.creditCard.rawValue,
            "userProductsRatingsIDs": [],
            "userProductsReviewsIDs": [],
            "imageURL": ""
        ]
        
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .setData(profileDocumentData) { (error) in
            if let error = error {
                print("Error creating user's profile data: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully created user's profile data for user: \(profile.username) identifying with id: \(profile.id) in database")
                completion(true, nil)
            }
        }
    }
    
    func createShipmentAddress(shipmentAddress: Address, completion: @escaping ((Bool, Error?) -> ())) {
        let shipmentAddressDocumentData: [String: Any] = [
            "id": shipmentAddress.id,
            "userID": shipmentAddress.userID,
            "fullName": shipmentAddress.fullName,
            "streetName": shipmentAddress.streetName,
            "streetNumber": shipmentAddress.streetNumber,
            "apartmentNumber": shipmentAddress.apartmentNumber,
            "zipCode": shipmentAddress.zipCode,
            "city": shipmentAddress.city,
            "country": shipmentAddress.country,
            "isDefaultAddress": shipmentAddress.isDefaultAddress
        ]
        
        self.db.collection(DatabaseCollections.shipmentAddresses.rawValue)
            .document(shipmentAddress.id)
            .setData(shipmentAddressDocumentData) { (error) in
            if let error = error {
                print("Error creating user's shipment address data: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully created user's shipment data for user identifying with id: \(shipmentAddress.userID) in database")
                completion(true, nil)
            }
        }
    }
    
    func createInvoiceAddress(invoiceAddress: Address, completion: @escaping ((Bool, Error?) -> ())) {
        let invoiceAddressDocumentData: [String: Any] = [
            "id": invoiceAddress.id,
            "userID": invoiceAddress.userID,
            "fullName": invoiceAddress.fullName,
            "streetName": invoiceAddress.streetName,
            "streetNumber": invoiceAddress.streetNumber,
            "apartmentNumber": invoiceAddress.apartmentNumber,
            "zipCode": invoiceAddress.zipCode,
            "city": invoiceAddress.city,
            "country": invoiceAddress.country,
            "isDefaultAddress": invoiceAddress.isDefaultAddress
        ]
        
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(invoiceAddress.id)
            .setData(invoiceAddressDocumentData) { (error) in
            if let error = error {
                print("Error creating user's invoice address data: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully created user's invoice address data for user identifying with id: \(invoiceAddress.userID) in database")
                completion(true, nil)
            }
        }
    }
}

extension FirestoreManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
