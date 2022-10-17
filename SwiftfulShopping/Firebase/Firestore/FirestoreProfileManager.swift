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
                    
                    completion(Address(id: id,
                                       userID: userID,
                                       fullName: fullName,
                                       streetName: streetName,
                                       streetNumber: streetNumber,
                                       apartmentNumber: apartmentNumber,
                                       zipCode: zipCode,
                                       city: city,
                                       country: country,
                                       isDefaultAddress: true))
                }
            }
    }
    
    
    // MARK: UPDATE DATABASE OPERATIONS
    
    func updateProfileData(profileID: String, profileDataToUpdate: [String: Any], completion: @escaping ((Bool, Error?) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profileID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating profile data: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    documentSnapshot?.reference.updateData(profileDataToUpdate)
                    print("Successfully updated profile data")
                    completion(true, nil)
                }
            }
    }
    
    func updateEmail(newEmail: String, profile: Profile, completion: @escaping ((Bool, Error?) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    completion(false, error)
                    print("Error updating email in profile data: \(error.localizedDescription)")
                } else {
                    let updateData: [String: Any] = [
                        "email": newEmail
                    ]
                    
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully updated email in profile data")
                    completion(true, nil)
                }
            }
    }
    
    func makeAddressInvoiceAddress(shipmentAddressToBeMakeInvoiceAddress: Address, completion: @escaping ((Result<Bool, Error>) -> ())) {
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .whereField("userID", isEqualTo: shipmentAddressToBeMakeInvoiceAddress.userID)
            .getDocuments { querySnapshot, error in
                if let invoiceAddressDocument = querySnapshot?.documents.first {
                    let updateData: [String: Any] = [
                        "id": shipmentAddressToBeMakeInvoiceAddress.id,
                        "userID": shipmentAddressToBeMakeInvoiceAddress.userID,
                        "fullName": shipmentAddressToBeMakeInvoiceAddress.fullName,
                        "streetName": shipmentAddressToBeMakeInvoiceAddress.streetName,
                        "streetNumber": shipmentAddressToBeMakeInvoiceAddress.streetNumber,
                        "apartmentNumber": shipmentAddressToBeMakeInvoiceAddress.apartmentNumber,
                        "zipCode": shipmentAddressToBeMakeInvoiceAddress.zipCode,
                        "city": shipmentAddressToBeMakeInvoiceAddress.city,
                        "country": shipmentAddressToBeMakeInvoiceAddress.country
                    ]
                    
                    self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
                        .document(invoiceAddressDocument.documentID)
                        .getDocument { documentSnapshot, error in
                            if let error = error {
                                print("Error updating invoice address data: \(error.localizedDescription)")
                                completion(.failure(error))
                            } else {
                                documentSnapshot?.reference.updateData(updateData)
                                print("Successfully updated invoice address data")
                                completion(.success(true))
                            }
                        }
                }
            }
    }
    
    // MARK: DELETE DATABASE OPERATIONS
    
    func deleteProfile(profile: Profile, completion: @escaping ((Bool, Error?) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error deleting profile data: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    documentSnapshot?.reference.delete()
                    print("Successfully deleted profile data")
                    completion(true, nil)
                }
            }
    }
    
    func deleteShipmentAddress(shipmentAddress: Address, completion: @escaping ((Bool, Error?) -> ())) {
        self.db.collection(DatabaseCollections.shipmentAddresses.rawValue)
            .document(shipmentAddress.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error deleting shipment address data: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    documentSnapshot?.reference.delete()
                    print("Successfully deleted shipment address data")
                    completion(true, nil)
                }
            }
    }
    
    func deleteShipmentAddress(invoiceAddress: Address, completion: @escaping ((Bool, Error?) -> ())) {
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(invoiceAddress.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error deleting invoice address data: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    documentSnapshot?.reference.delete()
                    print("Successfully deleted invoice address data")
                    completion(true, nil)
                }
            }
    }
}

extension FirestoreProfileManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
