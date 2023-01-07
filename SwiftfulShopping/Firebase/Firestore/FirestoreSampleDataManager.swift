//
//  FirestoreSampleDataManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/10/2022.
//

import Foundation
import Firebase

struct FirestoreSampleDataManager {
    static let db = Firestore.firestore()
    
    private init() {}
    
    
    // MARK: - -  INSERT DATABASE OPERATIONS
    
    // MARK: - -  Add sample Products and Ratings
    static func addAll(completion: @escaping ((VoidResult) -> ())) {
        addProducts { _ in
            addRatings { _ in
                addOrders { _ in
                    addReturns { _ in
                        addDiscounts { _ in
                            completion(.success)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - -  Add sample Products
    static func addProducts(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()
        
        for product in Product.demoProducts {
            group.enter()
            FirestoreProductsManager.addProduct(product: product) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    static func addSpecificationForExistingProducts(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()
        
        for product in Product.demoProducts {
            group.enter()
            FirestoreProductsManager.addSpecificationForExistingProduct(productID: product.id, productSpecification: product.specification) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: - -  Add sample Products
    static func addRatings(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for rating in ProductRating.demoProductsRatings {
            group.enter()
            FirestoreProductsManager.addProductRating(productRating: rating) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: - -  Add sample Orders
    static func addOrders(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for order in Order.demoOrders {
            group.enter()
            FirestoreOrdersManager.createUserOrder(order: order) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: - -  Add sample Returns
    static func addReturns(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for returnObject in Return.demoReturns {
            group.enter()
            FirestoreReturnsManager.createUserReturn(returnObject: returnObject) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: - -  Add sample Discounts
    static func addDiscounts(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for discount in Discount.demoDiscounts {
            group.enter()
            FirestoreProductsManager.addDiscount(discount: discount) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
}
