//
//  FirestoreOrdersManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation
import Firebase

class FirestoreOrdersManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreOrdersManager = {
        FirestoreOrdersManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getUserOrders(userID: String, completion: @escaping ((Result<[Order]?, Error>) -> ())) {
        db.collection(DatabaseCollections.orders.rawValue)
            .whereField("clientID", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching orders data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let orders = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Order in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let orderDate = data["orderDate"] as? Date ?? Date()
                        let estimatedDeliveryDate = data["estimatedDeliveryDate"] as? Date ?? Date()
                        let clientID = data["clientID"] as? String ?? ""
                        let clientDescription = data["clientDescription"] as? String ?? ""
                        let addressDescription = data["addressDescription"] as? String ?? ""
                        let shoppingCartID = data["shoppingCartID"] as? String ?? ""
                        let productsIDs = data["productsIDs"] as? [String] ?? []
                        let shippingMethod = data["shippingMethod"] as? String ?? ""
                        let shippingAddressID = data["shippingAddressID"] as? String ?? ""
                        let paymentMethod = data["paymentMethod"] as? String ?? ""
                        let invoice = data["invoice"] as? Bool ?? false
                        let totalCost = data["totalCost"] as? Double ?? 0.0
                        let status = data["status"] as? String ?? ""
                        
                        return Order(id: id,
                                     orderDate: orderDate,
                                     estimatedDeliveryDate: estimatedDeliveryDate,
                                     clientID: clientID,
                                     clientDescription: clientDescription,
                                     addressDescription: addressDescription,
                                     shoppingCartID: shoppingCartID,
                                     productsIDs: productsIDs,
                                     shippingMethod: ShippingMethod.withLabel(shippingMethod) ?? .courier,
                                     shippingAddressID: shippingAddressID,
                                     paymentMethod: PaymentMethod.withLabel(paymentMethod) ?? .creditCard,
                                     invoice: invoice,
                                     totalCost: totalCost,
                                     status: OrderStatus.withLabel(status) ?? .placed)
                    }
                    
                    print("Successfully fetched user orders data")
                    completion(.success(orders))
                }
            }
    }
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func createUserOrder(order: Order, completion: @escaping ((VoidResult) -> ())) {
        let profileDocumentData: [String: Any] = [
            "id": order.id,
            "orderDate": order.orderDate,
            "estimatedDeliveryDate": order.estimatedDeliveryDate,
            "clientID": order.clientID,
            "shoppingCartID": order.shoppingCartID,
            "productsIDs": order.productsIDs,
            "shippingMethod": order.shippingMethod.rawValue,
            "shippingAddressID": order.shippingAddressID,
            "paymentMethod": order.paymentMethod.rawValue,
            "invoice": order.invoice,
            "totalCost": order.totalCost,
            "status": order.status.rawValue
        ]
        
        self.db.collection(DatabaseCollections.orders.rawValue)
            .document(order.id)
            .setData(profileDocumentData) { (error) in
            if let error = error {
                print("Error creating user's order data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created user's order data for user identifying with id: \(order.clientID) in database")
                completion(.success)
            }
        }
    }
    
    
    // MARK: UPDATE DATABASE OPERATIONS
    
    func updateOrderStatus(order: Order, newStatus: OrderStatus, completion: @escaping ((VoidResult) -> ())) {
        let updateData: [String: Any] = [
            "status": newStatus.rawValue
        ]
        
        self.db.collection(DatabaseCollections.orders.rawValue)
            .document(order.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating order's status: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully changed status of order \(order.id) from \(order.status.rawValue) to \(newStatus.rawValue)")
                    completion(.success)
                }
            }
    }
}

extension FirestoreOrdersManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
