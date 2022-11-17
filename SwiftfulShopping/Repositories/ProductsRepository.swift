//
//  ProductsRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 24/07/2022.
//

import Foundation

class ProductsRepository: ObservableObject {
    @Published var products: [Product]?
    
    static var shared: ProductsRepository = {
        ProductsRepository()
    }()
    
    func fetchProducts(completion: @escaping (([Product]?) -> ())) {
        FirestoreProductsManager.getProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                completion(products)
            case .failure(let error):
                print("Error fetching products from repository: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func fetchTrendingSearches(completion: @escaping (([String]?) -> ())) {
        FirestoreProductsManager.getTrendingSearches { result in
            switch result {
            case .success(let searches):
                completion(searches)
            case .failure(_):
                completion([])
            }
        }
    }
}

extension ProductsRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
