//
//  ProductsRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 24/07/2022.
//

import Foundation

class ProductsRepository: ObservableObject {
    @Published var products: [Product] = []
    
    static var shared: ProductsRepository = {
        ProductsRepository()
    }()
    
    private init() {
        self.products = Product.demoProducts
    }
    
    func getProductFor(productID: String) -> Product? {
        for product in products where product.id == productID {
            return product
        }
        return nil
    }
    
    func addRatingFor(product: inout Product, authorID: String, authorFirstName: String, rating: Int, review: String?) {
        product.addRate(authorID: authorID, authorFirstName: authorFirstName, rating: rating, review: review)
    }
}

extension ProductsRepository: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
