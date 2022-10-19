//
//  FirestoreCartManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/10/2022.
//

import Foundation
import Firebase

class FirestoreCartsManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreCartsManager = {
        FirestoreCartsManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getOrderCart(orderID: String, completion: @escaping ((Result<Cart?, Error>) -> ())) {
        db.collection(DatabaseCollections.carts.rawValue)
            .whereField("orderID", isEqualTo: orderID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching orders data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let cart = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Cart in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let clientID = data["clientID"] as? String ?? ""
                        let orderID = data["orderID"] as? String ?? ""
                        let cartName = data["cartName"] as? String ?? ""
                        let productsIDsWithQuantity = data["productsIDsWithQuantity"] as? [String: Int] ?? [:]
                        let appliedDiscountsIDs = data["appliedDiscountsIDs"] as? [String] ?? []
                        let totalCost = data["totalCost"] as? Double ?? 0.0
                        let totalCostWithAppliedDiscounts = data["totalCostWithAppliedDiscounts"] as? Double ?? 0.0
                        
                        return Cart(id: id,
                                    clientID: clientID,
                                    orderID: orderID,
                                    cartName: cartName,
                                    productsIDsWithQuantity: productsIDsWithQuantity,
                                    appliedDiscountsIDs: appliedDiscountsIDs,
                                    totalCost: totalCost,
                                    totalCostWithAppliedDiscounts: totalCostWithAppliedDiscounts)
                    }
                        .first
                    
                    print("Successfully fetched order's cart data")
                    completion(.success(cart))
                }
            }
    }
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func createUserCart(cart: Cart, completion: @escaping ((VoidResult) -> ())) {
        let profileDocumentData: [String: Any] = [
            "id": cart.id,
            "clientID": cart.clientID,
            "orderID": cart.orderID,
            "cartName": cart.cartName,
            "productsIDsWithQuantity": cart.productsIDsWithQuantity,
            "appliedDiscountsIDs": cart.appliedDiscountsIDs,
            "totalCost": cart.totalCost,
            "totalCostWithAppliedDiscounts": cart.totalCostWithAppliedDiscounts
        ]
        
        self.db.collection(DatabaseCollections.carts.rawValue)
            .document(cart.id)
            .setData(profileDocumentData) { (error) in
            if let error = error {
                print("Error creating user's cart data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created user's cart data for user identifying with id: \(cart.clientID) in database")
                completion(.success)
            }
        }
    }
}

extension FirestoreCartsManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
