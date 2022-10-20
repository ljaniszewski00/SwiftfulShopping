//
//  OrdersRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class OrdersRepository: ObservableObject {
    @Published var userOrders: [Order]?
    
    static var shared: OrdersRepository = {
        OrdersRepository()
    }()
    
    private init() {}
    
    func fetchUserOrders(userID: String, completion: @escaping (([Order]?) -> ())) {
        FirestoreOrdersManager.client.getUserOrders(userID: userID) { result in
            switch result {
            case .success(let userOrders):
                completion(userOrders)
            case .failure(let error):
                print("Error fetching user orders from repository: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}

extension OrdersRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
