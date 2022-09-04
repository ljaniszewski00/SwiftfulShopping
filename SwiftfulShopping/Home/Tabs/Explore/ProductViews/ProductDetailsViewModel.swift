//
//  ProductDetailsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 06/08/2022.
//

import UIKit
import Kingfisher

class ProductDetailsViewModel: ObservableObject {
    @Published var fetchingProductImages: Bool = true
    @Published var productImages: [UIImage] = []
    
    @Published var productQuantityToBasket: Int = 1
    
    func fetchProductImages(productImagesURLs: [String]) {
        fetchingProductImages = true
        
        let group = DispatchGroup()
        for productImageURL in productImagesURLs {
            group.enter()
            KingfisherManager.shared.retrieveImage(with: URL(string: productImageURL)!) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.productImages.append(value.image)
                case .failure(let error):
                    break
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main, execute: { [weak self] in
            self?.fetchingProductImages = false
        })
    }
    
    func decreaseProductQuantity(by: Int = 1) {
        if productQuantityToBasket > 1 {
            productQuantityToBasket -= 1
        }
    }
    
    func increaseProductQuantity(by: Int = 1) {
        productQuantityToBasket += 1
    }
}
