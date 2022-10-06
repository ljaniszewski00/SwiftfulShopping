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
    
    func getUsersUIDs(completion: @escaping (([String]?) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents for users uids: \(error.localizedDescription)")
                } else {
                    let documentsIDs = querySnapshot?.documents.map {
                        $0.documentID
                    }
                    completion(documentsIDs)
                }
            }
    }
    
    func getUserProfile(userID: String, completion: @escaping ((Profile?) -> ())) {
        getShipmentAddressesFor(userID: userID) { [weak self] shipmentAddresses in
            if let shipmentAddresses = shipmentAddresses {
                self?.getInvoiceAddressFor(userID: userID) { [weak self] invoiceAddress in
                    if let invoiceAddress = invoiceAddress {
                        self?.db.collection(DatabaseCollections.profiles.rawValue)
                            .whereField("id", isEqualTo: userID)
                            .getDocuments { (querySnapshot, error) in
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
                                        let defaultShipmentAddress = shipmentAddresses.filter { $0.isDefaultAddress }.first!
                                        let defaultShippingMethod = data["defaultShippingMethod"] as? String ?? ""
                                        let defaultPaymentMethod = data["defaultPaymentMethod"] as? String ?? ""
                                        let userProductsRatings = data["userProductsRatingsIDs"] as? [String: Int] ?? [:]
                                        let userProductsReviews = data["userProductsReviewsIDs"] as? [String: String] ?? [:]
                                        let imageURL = data["imageURL"] as? String ?? ""
                                        let createdWith = data["createdWith"] as? String ?? ""
                                        
                                        return Profile(id: id,
                                                       fullName: fullName,
                                                       username: username,
                                                       birthDate: birthDate,
                                                       email: email,
                                                       country: Countries.withLabel(country) ?? .poland,
                                                       defaultShipmentAddress: defaultShipmentAddress,
                                                       shipmentAddresses: shipmentAddresses,
                                                       invoiceAddress: invoiceAddress,
                                                       defaultShippingMethod: ShippingMethod.withLabel(defaultShippingMethod) ?? .courier,
                                                       defaultPaymentMethod: PaymentMethod.withLabel(defaultPaymentMethod) ?? .creditCard,
                                                       userProductsRatings: userProductsRatings,
                                                       userProductsReviews: userProductsReviews,
                                                       imageURL: imageURL,
                                                       createdWith: SignInMethod.withLabel(createdWith))
                                        
                                    }
                                        .first
                                    
                                    completion(profile)
                                }
                            }
                    }
                }
            }
        }
    }
    
    func getShipmentAddressesFor(userID: String, completion: @escaping (([Address]?) -> ())) {
        self.db.collection(DatabaseCollections.shipmentAddresses.rawValue)
            .whereField("userID", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching shipment addresses data: \(error.localizedDescription)")
                } else {
                    let addresses = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Address in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let userID = data["userID"] as? String ?? ""
                        let fullName = data["fullName"] as? String ?? ""
                        let streetName = data["streetName"] as? String ?? ""
                        let streetNumber = data["streetNumber"] as? String ?? ""
                        let apartmentNumber = data["apartmentNumber"] as? String ?? ""
                        let zipCode = data["zipCode"] as? String ?? ""
                        let city = data["city"] as? String ?? ""
                        let country = data["country"] as? String ?? ""
                        let isDefaultAddress = data["isDefaultAddress"] as? Bool ?? false
                        
                        return Address(id: id,
                                       userID: userID,
                                       fullName: fullName,
                                       streetName: streetName,
                                       streetNumber: streetNumber,
                                       apartmentNumber: apartmentNumber,
                                       zipCode: zipCode,
                                       city: city,
                                       country: country,
                                       isDefaultAddress: isDefaultAddress)
                    }
                    
                    completion(addresses)
                }
            }
    }
    
    func getInvoiceAddressFor(userID: String, completion: @escaping ((Address?) -> ())) {
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(userID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error fetching invoice addresses data: \(error.localizedDescription)")
                } else {
                    guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        return
                    }
                    
                    guard let data = documentSnapshot.data() else {
                        return
                    }
                    
                    let id = data["id"] as? String ?? ""
                    let userID = data["userID"] as? String ?? ""
                    let fullName = data["fullName"] as? String ?? ""
                    let streetName = data["streetName"] as? String ?? ""
                    let streetNumber = data["streetNumber"] as? String ?? ""
                    let apartmentNumber = data["apartmentNumber"] as? String ?? ""
                    let zipCode = data["zipCode"] as? String ?? ""
                    let city = data["city"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let isDefaultAddress = data["isDefaultAddress"] as? Bool ?? false
                    
                    completion(Address(id: id,
                                       userID: userID,
                                       fullName: fullName,
                                       streetName: streetName,
                                       streetNumber: streetNumber,
                                       apartmentNumber: apartmentNumber,
                                       zipCode: zipCode,
                                       city: city,
                                       country: country,
                                       isDefaultAddress: isDefaultAddress))
                }
            }
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
            "username": profile.username ?? "",
            "birthDate": profile.birthDate ?? "",
            "email": profile.email ?? "",
            "country": profile.country.rawValue,
            "defaultShipmentAddressID": profile.defaultShipmentAddress.id,
            "shipmentAddressesIDs": [profile.defaultShipmentAddress.id],
            "invoiceAddressID": profile.invoiceAddress.id,
            "defaultShippingMethod": ShippingMethod.courier.rawValue,
            "defaultPaymentMethod": PaymentMethod.creditCard.rawValue,
            "userProductsRatingsIDs": [],
            "userProductsReviewsIDs": [],
            "imageURL": "",
            "createdWith": profile.createdWith?.rawValue ?? ""
        ]
        
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .setData(profileDocumentData) { (error) in
            if let error = error {
                print("Error creating user's profile data: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully created user's profile data for user identifying with id: \(profile.id) in database")
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
