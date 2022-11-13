//
//  FirestoreSampleDataManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/10/2022.
//

import Foundation
import Firebase

class FirestoreSampleDataManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreSampleDataManager = {
        FirestoreSampleDataManager()
    }()
    
    private init() {}
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    // MARK: Add sample Products and Ratings
    func addAll(completion: @escaping ((VoidResult) -> ())) {
        addProducts { [weak self] _ in
            self?.addRatings { [weak self] _ in
                self?.addOrders { [weak self] _ in
                    self?.addReturns { [weak self] _ in
                        self?.addDiscounts { _ in
                            completion(.success)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Add sample Products
    func addProducts(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()
        
        for product in Product.demoProducts {
            group.enter()
            FirestoreProductsManager.client.addProduct(product: product) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    func addSpecificationForExistingProducts(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()
        
        for product in Product.demoProducts {
            group.enter()
            FirestoreProductsManager.client.addSpecificationForExistingProduct(productID: product.id, productSpecification: product.specification) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: Add sample Products
    func addRatings(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for rating in ProductRating.demoProductsRatings {
            group.enter()
            FirestoreProductsManager.client.addProductRating(productRating: rating) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: Add sample Orders
    func addOrders(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for order in Order.demoOrders {
            group.enter()
            FirestoreOrdersManager.client.createUserOrder(order: order) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: Add sample Returns
    func addReturns(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for returnObject in Return.demoReturns {
            group.enter()
            FirestoreReturnsManager.client.createUserReturn(returnObject: returnObject) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: Add sample Discounts
    func addDiscounts(completion: @escaping ((VoidResult) -> ())) {
        let group = DispatchGroup()

        for discount in Discount.demoDiscounts {
            group.enter()
            FirestoreProductsManager.client.addDiscount(discount: discount) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion(.success)
        }
    }
}

extension FirestoreSampleDataManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
