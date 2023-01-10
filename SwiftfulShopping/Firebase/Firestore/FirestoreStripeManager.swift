//
//  FirestoreStripeManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/11/2022.
//

import Foundation
import Firebase

struct FirestoreStripeManager {
    static private let db = Firestore.firestore()
    
    private init() {}
    
    
    // MARK: - SELECT DATABASE OPERATIONS
    
    static func listenToStripeCheckoutSession(profileID: String, checkoutSessionDocumentID: String, completion: @escaping ((Result<[String: String]?, Error>) -> ())) {
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profileID)
            .collection("checkout_sessions")
            .document(checkoutSessionDocumentID)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let data = documentSnapshot?.data() {
                        guard let paymentIntentClientSecret = data["paymentIntentClientSecret"] as? String,
                              let ephemeralKeySecret = data["ephemeralKeySecret"] as? String,
                              let customer = data["customer"] as? String else { return }
                        
                        let checkoutSessionData: [String: String] = [
                            "paymentIntentClientSecret": paymentIntentClientSecret,
                            "ephemeralKeySecret": ephemeralKeySecret,
                            "customer": customer
                        ]
                        
                        completion(.success(checkoutSessionData))
                    }
                }
            }
    }


    // MARK: - INSERT DATABASE OPERATIONS

    static func createStripeCheckoutSession(profileID: String, amount: Int, currency: String, completion: @escaping ((Result<String, Error>) -> ())) {
        let documentData: [String: Any] = [
            "client": "mobile",
            "mode": "payment",
            "amount": amount,
            "currency": currency
        ]
        
        let documentID = UUID().uuidString
        
        self.db.collection(DatabaseCollections.profiles.rawValue)
            .document(profileID)
            .collection("checkout_sessions")
            .document(documentID)
            .setData(documentData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(documentID))
                }
            }
    }
}
