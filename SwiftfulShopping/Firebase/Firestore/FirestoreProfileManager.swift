//
//  FirestoreProfileManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation
import Firebase

struct FirestoreProfileManager {
    static private let db = Firestore.firestore()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    static func getUserProfile(userID: String, completion: @escaping ((Result<Profile?, Error>) -> ())) {
        getShipmentAddressesFor(userID: userID) { getShipmentAddressesResult in
            switch getShipmentAddressesResult {
            case .success(let shipmentAddresses):
                if let shipmentAddresses = shipmentAddresses {
                    getInvoiceAddressFor(userID: userID) { getInvoiceAddressResult in
                        switch getInvoiceAddressResult {
                        case .success(let invoiceAddress):
                            if let invoiceAddress = invoiceAddress {
                                db.collection(DatabaseCollections.profiles.rawValue)
                                    .whereField("id", isEqualTo: userID)
                                    .addSnapshotListener { (querySnapshot, error) in
                                        if let error = error {
                                            print("Error fetching profile data: \(error.localizedDescription)")
                                            completion(.failure(error))
                                        } else {
                                            let profile = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Profile in
                                                
                                                let data = queryDocumentSnapshot.data()

                                                let id = data["id"] as? String ?? ""
                                                let fullName = data["fullName"] as? String ?? ""
                                                let username = data["username"] as? String ?? ""
                                                let birthDateTimestamp = data["birthDate"] as? Timestamp
                                                let email = data["email"] as? String ?? ""
                                                let country = data["country"] as? String ?? ""
                                                let defaultShipmentAddress = shipmentAddresses.filter { $0.isDefaultAddress }.first ?? shipmentAddresses[0]
                                                let defaultShippingMethod = data["defaultShippingMethod"] as? String ?? ""
                                                let defaultPaymentMethod = data["defaultPaymentMethod"] as? String ?? ""
                                                let imageURL = data["imageURL"] as? String ?? ""
                                                let createdWith = data["createdWith"] as? String ?? ""
                                                
                                                let birthDate = birthDateTimestamp?.dateValue() ?? Date()
                                                
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
                                                               imageURL: imageURL,
                                                               createdWith: SignInMethod.withLabel(createdWith))
                                                
                                            }
                                                .first
                                            
                                            completion(.success(profile))
                                        }
                                    }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getShipmentAddressesFor(userID: String, completion: @escaping ((Result<[Address]?, Error>) -> ())) {
        self.db.collection(DatabaseCollections.shipmentAddresses.rawValue)
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching shipment addresses data: \(error.localizedDescription)")
                    completion(.failure(error))
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
                    
                    completion(.success(addresses))
                }
            }
    }
    
    static func getInvoiceAddressFor(userID: String, completion: @escaping ((Result<Address?, Error>) -> ())) {
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching invoice addresses data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let invoiceAddress = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Address in
                        
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
                        
                        return Address(id: id,
                                       userID: userID,
                                       fullName: fullName,
                                       streetName: streetName,
                                       streetNumber: streetNumber,
                                       apartmentNumber: apartmentNumber,
                                       zipCode: zipCode,
                                       city: city,
                                       country: country,
                                       isDefaultAddress: true)
                    }
                        .first
                    
                    completion(.success(invoiceAddress))
                }
            }
    }
    
    static func getNewestPaymentIDFor(profileID: String, completion: @escaping ((Result<String?, Error>) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profileID)
            .collection("payments")
            .order(by: "created", descending: true).limit(to: 1)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let querySnapshot = querySnapshot else { return }
                    
                    let paymentID = querySnapshot.documents.map { (queryDocumentSnapshot) -> String? in
                        let data = queryDocumentSnapshot.data()
                        return data["id"] as? String
                    }
                    .first
                    
                    guard let firstPaymentID = paymentID else { return }
                    completion(.success(firstPaymentID))
                }
            }
    }
    
    
    // MARK: UPDATE DATABASE OPERATIONS
    
    static func updateProfileData(profileID: String, profileDataToUpdate: [String: Any], completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profileID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating profile data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.updateData(profileDataToUpdate)
                    print("Successfully updated profile data")
                    completion(.success)
                }
            }
    }
    
    static func updateProfileImageURL(profileID: String, imageURL: String, completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profileID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating profile image url data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let updateData: [String: Any] = [
                        "imageURL": imageURL
                    ]
                    
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully updated profile image url data")
                    completion(.success)
                }
            }
    }
    
    static func updateEmail(newEmail: String, profile: Profile, completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating email in profile data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let updateData: [String: Any] = [
                        "email": newEmail
                    ]
                    
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully updated email in profile data")
                    completion(.success)
                }
            }
    }
    
    static func makeAddressInvoiceAddress(shipmentAddressToBeMadeInvoiceAddress: Address, completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .whereField("userID", isEqualTo: shipmentAddressToBeMadeInvoiceAddress.userID)
            .getDocuments { querySnapshot, error in
                if let invoiceAddressDocument = querySnapshot?.documents.first {
                    let updateData: [String: Any] = [
                        "id": shipmentAddressToBeMadeInvoiceAddress.id,
                        "userID": shipmentAddressToBeMadeInvoiceAddress.userID,
                        "fullName": shipmentAddressToBeMadeInvoiceAddress.fullName,
                        "streetName": shipmentAddressToBeMadeInvoiceAddress.streetName,
                        "streetNumber": shipmentAddressToBeMadeInvoiceAddress.streetNumber,
                        "apartmentNumber": shipmentAddressToBeMadeInvoiceAddress.apartmentNumber,
                        "zipCode": shipmentAddressToBeMadeInvoiceAddress.zipCode,
                        "city": shipmentAddressToBeMadeInvoiceAddress.city,
                        "country": shipmentAddressToBeMadeInvoiceAddress.country
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
                                completion(.success)
                            }
                        }
                }
            }
    }
    
    static func makeAddressDefaultShippingAddress(userID: String,
                                           shipmentAddressToBeMadeDefaultAddress: Address,
                                           completion: @escaping ((VoidResult) -> ())) {
        let dataToUpdateForAllDocuments: [String: Any] = [
            "isDefaultAddress": false
        ]
        
        let dataToUpdateForOneDocument: [String: Any] = [
            "isDefaultAddress": true
        ]
        
        let dispatchGroup = DispatchGroup()
        
        self.db.collection(DatabaseCollections.shipmentAddresses.rawValue)
            .whereField("userID", isEqualTo: userID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    for document in querySnapshot!.documents {
                        dispatchGroup.enter()
                        if document.documentID == shipmentAddressToBeMadeDefaultAddress.id {
                            document.reference.updateData(dataToUpdateForOneDocument)
                        } else {
                            document.reference.updateData(dataToUpdateForAllDocuments)
                        }
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(.success)
                    }
                }
            }
    }
    
    static func changeDefaultPaymentMethod(userID: String,
                                    newDefaultPaymentMethod: String,
                                    completion: @escaping ((VoidResult) -> ())) {
        let dataToUpdate: [String: Any] = [
            "defaultPaymentMethod": newDefaultPaymentMethod
        ]
        
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(userID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.updateData(dataToUpdate)
                    completion(.success)
                }
            }
    }
    
    // MARK: DELETE DATABASE OPERATIONS
    
    static func deleteProfile(profile: Profile, completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profile.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error deleting profile data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.delete()
                    print("Successfully deleted profile data")
                    completion(.success)
                }
            }
    }
    
    static func deleteShipmentAddress(shipmentAddress: Address, completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.shipmentAddresses.rawValue)
            .document(shipmentAddress.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error deleting shipment address data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.delete()
                    print("Successfully deleted shipment address data")
                    completion(.success)
                }
            }
    }
    
    static func deleteInvoiceAddress(invoiceAddress: Address, completion: @escaping ((VoidResult) -> ())) {
        self.db.collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(invoiceAddress.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error deleting invoice address data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.delete()
                    print("Successfully deleted invoice address data")
                    completion(.success)
                }
            }
    }
}
