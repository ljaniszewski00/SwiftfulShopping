//
//  OnboardingViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/11/2022.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @AppStorage(AppStorageConstants.shouldShowOnboarding) var shouldShowOnboarding: Bool = true
    @Published var onboardingTilesPhotos: [UIImage] = []
    
    var onboardingTilesNumbersRange: ClosedRange<Int> = 0...10
    
    let onboardingTilesHeadings: [Int: String] = [
        0: "Explore thousands of products from different cattegories",
        1: "Product details at your fingertips",
        2: "Look for yourself how others rate various products",
        3: "Sort and Filter products to find exactly the products you are looking for",
        4: "Compare specifications of up to 4 products of same category",
        5: "Shopping process easy like never before",
        6: "See details of every order and return you created",
        7: "Find what you like the way you like",
        8: "Recognize products with the tap of one button",
        9: "Easily manage all app's settings",
        10: ""
    ]
    
    let onboardingTilesDescriptions: [Int: String] = [
        0: "",
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: ""
    ]
    
    func getOnboardingTilesPhotos(completion: @escaping ((VoidResult) -> ())) {
        FirebaseStorageManager.downloadOnboardingImagesFromStorage { [weak self] result in
            switch result {
            case .success(let images):
                self?.onboardingTilesPhotos = images
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
