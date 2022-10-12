//
//  FirestoreProfileManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation
import Firebase

class FirestoreProfileManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreProfileManager = {
        FirestoreProfileManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
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
}

extension FirestoreProfileManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
