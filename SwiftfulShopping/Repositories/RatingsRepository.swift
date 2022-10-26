//
//  RatingsRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class RatingsRepository: ObservableObject {
    @Published var ratings: [ProductRating]?
    
    static var shared: RatingsRepository = {
        RatingsRepository()
    }()
    
    private init() {
        fetchRatings { [weak self] productRatings in
            self?.ratings = productRatings
        }
    }
    
    func fetchRatings(completion: @escaping (([ProductRating]?) -> ())) {
        FirestoreProductsManager.client.getRatings { result in
            switch result {
            case .success(let ratings):
                completion(ratings)
            case .failure(let error):
                print("Error fetching ratings from repository: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func getRatingsFor(productID: String, completion: @escaping ((Result<[ProductRating]?, Error>) -> ())) {
        FirestoreProductsManager.client.getProductRatings(productID: productID) { result in
            switch result {
            case .success(let rating):
                completion(.success(rating))
            case .failure(let error):
                print("Error getting ratings for product: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

extension RatingsRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}