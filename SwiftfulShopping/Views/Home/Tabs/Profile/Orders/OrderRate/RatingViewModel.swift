//
//  RatingViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/08/2022.
//

import Foundation

class RatingViewModel: ObservableObject {
    @Published var shouldPresentSingleProductRatingPage: Bool = false
    
    @Published var activeProduct: Product?
    @Published var productRating: Int = 0
    @Published var textForRating: String = ""
    
    @Published var showLoadingModal: Bool = false
    
    var cannotAddOpinion: Bool {
        ratingIsNotValid || ratingTextTooLong
    }
    
    var ratingIsNotValid: Bool {
        productRating <= 0
    }
    
    var ratingTextTooLong: Bool {
        textForRating.count > 300
    }
    
    func clearForNextProduct() {
        productRating = 0
        textForRating = ""
    }
    
    func setProductRating(rating: Int) {
        productRating = rating
    }
    
    func getProductsListForOrderRating(order: Order) -> [Product] {
        if let products = ProductsRepository.shared.products {
            return products.filter { order.productsIDs.contains($0.id) }.sorted { $0.name < $1.name }
        } else {
            return []
        }
    }
    
    func applyProductRating(authorID: String, authorFirstName: String, completion: @escaping ((VoidResult) -> ())) {
        let productRating = ProductRating(id: UUID().uuidString,
                                          productID: activeProduct?.id ?? "Error",
                                          authorID: authorID,
                                          authorFirstName: authorFirstName,
                                          rating: productRating,
                                          review: textForRating,
                                          date: Date())
        
        showLoadingModal = true
        
        FirestoreProductsManager.client.addProductRating(userID: authorID,
                                                         productRating: productRating) { [weak self] result in
            self?.showLoadingModal = false
            completion(result)
        }
    }
}
