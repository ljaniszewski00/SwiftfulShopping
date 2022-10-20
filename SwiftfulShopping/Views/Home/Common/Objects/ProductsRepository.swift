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
    
    private init() {
        fetchProducts { [weak self] products in
            self?.products = products
        }
    }
    
    func fetchProducts(completion: @escaping (([Product]?) -> ())) {
        FirestoreProductsManager.client.getProducts { result in
            switch result {
            case .success(let products):
                completion(products)
            case .failure(let error):
                print("Error fetching products from repository: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func getProductFor(productID: String) -> Product? {
        return products?.filter { $0.id == productID }.first
    }
}

extension ProductsRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
