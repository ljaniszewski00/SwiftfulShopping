//
//  FirestoreReturnsManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation
import Firebase

class FirestoreReturnsManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreReturnsManager = {
        FirestoreReturnsManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getUserReturns(userID: String, completion: @escaping ((Result<[Return]?, Error>) -> ())) {
        db.collection(DatabaseCollections.returns.rawValue)
            .whereField("clientID", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching returns data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let returns = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Return in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let returnDate = data["returnDate"] as? Date ?? Date()
                        let clientID = data["clientID"] as? String ?? ""
                        let orderID = data["orderID"] as? String ?? ""
                        let productsIDs = data["productsIDs"] as? [String] ?? []
                        let returnPrice = data["returnPrice"] as? Double ?? 0.0
                        let returnMethod = data["returnMethod"] as? String ?? ""
                        let status = data["status"] as? String ?? ""
                        let bankAccountNumber = data["bankAccountNumber"] as? String ?? ""
                        let bankAccountOwnerName = data["bankAccountOwnerName"] as? String ?? ""
                        let bankAccountOwnerStreetAndHouseNumber = data["bankAccountOwnerStreetAndHouseNumber"] as? String ?? ""
                        let bankAccountOwnerPostalCode = data["bankAccountOwnerPostalCode"] as? String ?? ""
                        let bankAccountOwnerCity = data["bankAccountOwnerCity"] as? String ?? ""
                        let bankAccountOwnerCountry = data["bankAccountOwnerCountry"] as? String ?? ""
                        
                        return Return(id: id,
                                      returnDate: returnDate,
                                      clientID: clientID,
                                      orderID: orderID,
                                      productsIDs: productsIDs,
                                      returnPrice: returnPrice,
                                      returnMethod: ShippingMethod.withLabel(returnMethod) ?? .courier,
                                      status: ReturnStatus.withLabel(status) ?? .reported,
                                      bankAccountNumber: bankAccountNumber,
                                      bankAccountOwnerName: bankAccountOwnerName,
                                      bankAccountOwnerStreetAndHouseNumber: bankAccountOwnerStreetAndHouseNumber,
                                      bankAccountOwnerPostalCode: bankAccountOwnerPostalCode,
                                      bankAccountOwnerCity: bankAccountOwnerCity,
                                      bankAccountOwnerCountry: bankAccountOwnerCountry)
                        
                    }
                    
                    print("Successfully fetched user returns data")
                    completion(.success(returns))
                }
            }
    }
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func createUserReturn(returnObject: Return, completion: @escaping ((VoidResult) -> ())) {
        let profileDocumentData: [String: Any] = [
            "id": returnObject.id,
            "returnDate": returnObject.returnDate,
            "clientID": returnObject.clientID,
            "orderID": returnObject.orderID,
            "productsIDs": returnObject.productsIDs,
            "returnPrice": returnObject.returnPrice,
            "returnMethod": returnObject.returnMethod,
            "status": returnObject.status,
            "bankAccountNumber": returnObject.bankAccountNumber,
            "bankAccountOwnerName": returnObject.bankAccountOwnerName,
            "bankAccountOwnerStreetAndHouseNumber": returnObject.bankAccountOwnerStreetAndHouseNumber,
            "bankAccountOwnerPostalCode": returnObject.bankAccountOwnerPostalCode,
            "bankAccountOwnerCity": returnObject.bankAccountOwnerCity,
            "bankAccountOwnerCountry": returnObject.bankAccountOwnerCountry
        ]
        
        self.db.collection(DatabaseCollections.returns.rawValue)
            .document(returnObject.id)
            .setData(profileDocumentData) { (error) in
            if let error = error {
                print("Error creating user's return data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created user's return data for user identifying with id: \(returnObject.clientID) in database")
                completion(.success)
            }
        }
    }
    
    
    // MARK: UPDATE DATABASE OPERATIONS
    
    func updateReturnStatus(returnObject: Return, newStatus: ReturnStatus, completion: @escaping ((VoidResult) -> ())) {
        let updateData: [String: Any] = [
            "status": newStatus.rawValue
        ]
        
        self.db.collection(DatabaseCollections.returns.rawValue)
            .document(returnObject.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating return's status: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully changed status of return \(returnObject.id) from \(returnObject.status.rawValue) to \(newStatus.rawValue)")
                    completion(.success)
                }
            }
    }
}

extension FirestoreReturnsManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
