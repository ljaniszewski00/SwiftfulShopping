//
//  FirestoreProductsManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

class FirestoreProductsManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreProductsManager = {
        FirestoreProductsManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getProducts(userID: String, completion: @escaping (([Order]?) -> ())) {
        
    }
    
    func getProductRatings(productID: String, completion: @escaping (()))
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func createUserOrder(order: Order, completion: @escaping ((Bool, Error?) -> ())) {
        
    }
}

extension FirestoreProductsManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
