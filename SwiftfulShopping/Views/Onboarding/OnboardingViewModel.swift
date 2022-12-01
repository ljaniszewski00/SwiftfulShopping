//
//  OnboardingViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/11/2022.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @AppStorage(AppStorageConstants.shouldShowOnboarding) var shouldShowOnboarding: Bool = true
    @Published var onboardingTilesPhotosModels: [OnboardingImageModel] = []
    
    @Published var showLoadingModal: Bool = false
    
    var onboardingTilesNumbersRange: ClosedRange<Int> {
        0...(onboardingTilesPhotosModels.count)
    }
    
    let onboardingTilesHeadings: [Int: String] = [
        0: "Explore thousands of products",
        1: "Product details at your fingertips",
        2: "Look for yourself how others rate the product",
        3: "Sort and Filter products to find exactly the products you are looking for",
        4: "Compare specifications of up to 4 products of same category",
        5: "Shopping process easy like never before",
        6: "See details of every order and return you created",
        7: "Find what you like the way you like",
        8: "Recognize products with the tap of one button",
        9: "Easily manage all app's settings"
    ]
    
    let onboardingTilesDescriptions: [Int: String] = [
        0: "All the products offered buy a seller are available for you to be choosen from many categories",
        1: "Let nothing distract you. Get to know all the products details including description, specifications and rating",
        2: "After having bought something you have possibility to write your own review and rate the product. All reviews can be seen on products page",
        3: "Want to see only products from specific company? Only products that price is in particular bounds? You have the possibility to sort and filter products any way you want",
        4: "After choosing particular products you have the possibility to compare specification of every one of them next to each other",
        5: "Add to cart, choose shipment and payment option, confirm and pay. This is it. And what's more, you can always pay later in orders section of your profile",
        6: "In orders and returns section of your profile you can find all the information about present and historical orders and returns that you created",
        7: "Seach tab enables you to find the product you are looking for by searching from text, ready trending searches and even your own camera",
        8: "Just take a photo of a product or upload one and all matching products available will be displayed",
        9: "Many settings let you personalize and set the app the way you like. Here you can also change your e-mail, password and even delete the account along with all the data"
    ]
    
    func getOnboardingTilesPhotos(completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        
        FirebaseStorageManager.downloadOnboardingImagesFromStorage { [weak self] result in
            switch result {
            case .success(let imagesModels):
                self?.onboardingTilesPhotosModels = imagesModels.sorted { $0.id < $1.id }
                self?.showLoadingModal = false
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
