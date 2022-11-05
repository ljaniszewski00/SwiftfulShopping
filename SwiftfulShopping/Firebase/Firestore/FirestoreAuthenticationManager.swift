//
//  FirestoreAuthenticationManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 05/10/2022.
//

import Foundation
import Firebase

class FirestoreAuthenticationManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreAuthenticationManager = {
        FirestoreAuthenticationManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getUsersUIDs(completion: @escaping ((Result<[String]?, Error>) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents for users uids: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let documentsIDs = querySnapshot?.documents.map {
                        $0.documentID
                    }
                    completion(.success(documentsIDs))
                }
            }
    }
    
    func listenToUsersUsernamesAndEmails(completion: @escaping ((Result<([String]?, [String]?), Error>)) -> Void) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents for users usernames: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let usernames = querySnapshot?.documents.map {
                        let data = $0.data()
                        return data["username"] as? String ?? ""
                    }
                    let emails = querySnapshot?.documents.map {
                        let data = $0.data()
                        return data["emails"] as? String ?? ""
                    }
                    completion(.success((usernames, emails)))
                }
            }
    }
    
    func cancelListening(listener: ListenerRegistration) {
        listener.remove()
    }
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func createProfile(profile: Profile, completion: @escaping ((VoidResult) -> ())) {
        let profileDocumentData: [String: Any] = [
            "id": profile.id,
            "fullName": profile.fullName,
            "username": profile.username ?? "",
            "birthDate": profile.birthDate ?? "",
            "email": profile.email ?? "",
            "country": profile.country.decodeValue,
            "defaultShipmentAddressID": profile.defaultShipmentAddress.id,
            "shipmentAddressesIDs": [profile.defaultShipmentAddress.id],
            "invoiceAddressID": profile.invoiceAddress.id,
            "defaultShippingMethod": ShippingMethod.courier.decodeValue,
            "defaultPaymentMethod": PaymentMethod.creditCard.decodeValue,
            "userProductsRatingsIDs": [],
            "userProductsReviewsIDs": [],
            "imageURL": "",
            "createdWith": profile.createdWith?.decodeValue ?? ""
        ]
        
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .setData(profileDocumentData) { (error) in
            if let error = error {
                print("Error creating user's profile data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created user's profile data for user identifying with id: \(profile.id) in database")
                completion(.success)
            }
        }
    }
    
    func createShipmentAddress(shipmentAddress: Address, completion: @escaping ((VoidResult) -> ())) {
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
                completion(.failure(error))
            } else {
                print("Successfully created user's shipment data for user identifying with id: \(shipmentAddress.userID) in database")
                completion(.success)
            }
        }
    }
    
    func createInvoiceAddress(invoiceAddress: Address, completion: @escaping ((VoidResult) -> ())) {
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
        ]
        
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(invoiceAddress.id)
            .setData(invoiceAddressDocumentData) { (error) in
            if let error = error {
                print("Error creating user's invoice address data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created user's invoice address data for user identifying with id: \(invoiceAddress.userID) in database")
                completion(.success)
            }
        }
    }
}

extension FirestoreAuthenticationManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
