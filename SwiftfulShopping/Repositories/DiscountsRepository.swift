//
//  DiscountsRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class DiscountsRepository: ObservableObject {
    @Published var discounts: [Discount]?
    
    static var shared: DiscountsRepository = {
        DiscountsRepository()
    }()
    
    func fetchDiscounts(completion: @escaping (([Discount]?) -> ())) {
        FirestoreProductsManager.client.getDiscounts { [weak self] result in
            switch result {
            case .success(let discounts):
                self?.discounts = discounts
                completion(discounts)
            case .failure(let error):
                print("Error fetching discounts from repository: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func getDiscountsFor(productID: String, completion: @escaping ((Result<[Discount]?, Error>) -> ())) {
        FirestoreProductsManager.client.getDiscountsFor(productID: productID) { result in
            switch result {
            case .success(let discounts):
                completion(.success(discounts))
            case .failure(let error):
                print("Error getting discounts for product: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

extension DiscountsRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
