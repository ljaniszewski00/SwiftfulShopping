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
                        let orderDateTimestamp = data["orderDate"] as? Timestamp
                        let estimatedDeliveryDateTimestamp = data["estimatedDeliveryDate"] as? Timestamp
                        let clientID = data["clientID"] as? String ?? ""
                        let clientDescription = data["clientDescription"] as? String ?? ""
                        let addressDescription = data["addressDescription"] as? String ?? ""
                        let productsIDsWithQuantity = data["productsIDsWithQuantity"] as? [String: Int] ?? [:]
                        let shippingMethod = data["shippingMethod"] as? String ?? ""
                        let shippingAddressID = data["shippingAddressID"] as? String ?? ""
                        let paymentMethod = data["paymentMethod"] as? String ?? ""
                        let invoice = data["invoice"] as? Bool ?? false
                        let productsCost = data["productsCost"] as? Double ?? 0.0
                        let appliedDiscountsCodesWithValue = data["appliedDiscountsCodesWithValue"] as? [String: Double] ?? [:]
                        let shippingCost = data["shippingCost"] as? Double ?? 0.0
                        let paymentCost = data["paymentCost"] as? Double ?? 0.0
                        let totalCost = data["totalCost"] as? Double ?? 0.0
                        let status = data["status"] as? String ?? ""
                        
                        let orderDate = orderDateTimestamp?.dateValue() ?? Date()
                        let estimatedDeliveryDate = estimatedDeliveryDateTimestamp?.dateValue() ?? Date()
                        
                        return Order(id: id,
                                     orderDate: orderDate,
                                     estimatedDeliveryDate: estimatedDeliveryDate,
                                     clientID: clientID,
                                     clientDescription: clientDescription,
                                     addressDescription: addressDescription,
                                     productsIDsWithQuantity: productsIDsWithQuantity,
                                     shippingMethod: ShippingMethod.withLabel(shippingMethod) ?? .courier,
                                     shippingAddressID: shippingAddressID,
                                     paymentMethod: PaymentMethod.withLabel(paymentMethod) ?? .creditCard,
                                     invoice: invoice,
                                     productsCost: productsCost,
                                     appliedDiscountsCodesWithValue: appliedDiscountsCodesWithValue,
                                     shippingCost: shippingCost,
                                     paymentCost: paymentCost,
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
            "productsIDsWithQuantity": order.productsIDsWithQuantity,
            "shippingMethod": order.shippingMethod.decodeValue,
            "shippingAddressID": order.shippingAddressID,
            "paymentMethod": order.paymentMethod.decodeValue,
            "invoice": order.invoice,
            "productsCost": order.productsCost,
            "appliedDiscountsCodesWithValue": order.appliedDiscountsCodesWithValue,
            "shippingCost": order.shippingCost,
            "paymentCost": order.paymentCost,
            "totalCost": order.totalCost,
            "status": order.status.decodeValue
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
            "status": newStatus.decodeValue
        ]
        
        self.db.collection(DatabaseCollections.orders.rawValue)
            .document(order.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error updating order's status: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully changed status of order \(order.id) from \(order.status.decodeValue) to \(newStatus.decodeValue)")
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
