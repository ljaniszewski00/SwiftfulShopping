//
//  ReturnsRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class ReturnsRepository: ObservableObject {
    @Published var userReturns: [Return]?
    
    static var shared: ReturnsRepository = {
        ReturnsRepository()
    }()
    
    private init() {}
    
    func fetchUserReturns(userID: String, completion: @escaping (([Return]?) -> ())) {
        FirestoreReturnsManager.client.getUserReturns(userID: userID) { result in
            switch result {
            case .success(let userReturns):
                completion(userReturns)
            case .failure(let error):
                print("Error fetching user orders from repository: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}

extension ReturnsRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
