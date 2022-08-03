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
    
    func applyProductRating(userID: String) {
        ProductsRepository.shared.addRatingFor(product: &(activeProduct)!, userID: userID, rating: productRating, review: textForRating.isEmpty ? nil : textForRating)
    }
}
