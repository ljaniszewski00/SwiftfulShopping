//
//  OnboardingViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/11/2022.
//

import SwiftUI
import texterify_ios_sdk

class OnboardingViewModel: ObservableObject {
    @AppStorage(AppStorageConstants.shouldShowOnboarding) var shouldShowOnboarding: Bool = true
    @Published var onboardingTilesPhotosModels: [OnboardingImageModel] = []
    
    @Published var showLoadingModal: Bool = false
    @Published var shouldDismiss: Bool = false
    
    var onboardingTilesNumbersRange: ClosedRange<Int> {
        0...(onboardingTilesPhotosModels.count)
    }
    
    let onboardingTilesHeadings: [Int: String] = [
        0: TexterifyManager.localisedString(key: .onboardingView(.firstTileHeading)),
        1: TexterifyManager.localisedString(key: .onboardingView(.secondTileHeading)),
        2: TexterifyManager.localisedString(key: .onboardingView(.thirdTileHeading)),
        3: TexterifyManager.localisedString(key: .onboardingView(.fourthTileHeading)),
        4: TexterifyManager.localisedString(key: .onboardingView(.fifthTileHeading)),
        5: TexterifyManager.localisedString(key: .onboardingView(.sixthTileHeading)),
        6: TexterifyManager.localisedString(key: .onboardingView(.seventhTileHeading)),
        7: TexterifyManager.localisedString(key: .onboardingView(.eighthTileHeading)),
        8: TexterifyManager.localisedString(key: .onboardingView(.ninthTileHeading)),
        9: TexterifyManager.localisedString(key: .onboardingView(.tenthTileHeading))
    ]
    
    let onboardingTilesDescriptions: [Int: String] = [
        0: TexterifyManager.localisedString(key: .onboardingView(.firstTileDescription)),
        1: TexterifyManager.localisedString(key: .onboardingView(.secondTileDescription)),
        2: TexterifyManager.localisedString(key: .onboardingView(.thirdTileDescription)),
        3: TexterifyManager.localisedString(key: .onboardingView(.fourthTileDescription)),
        4: TexterifyManager.localisedString(key: .onboardingView(.fifthTileDescription)),
        5: TexterifyManager.localisedString(key: .onboardingView(.sixthTileDescription)),
        6: TexterifyManager.localisedString(key: .onboardingView(.seventhTileDescription)),
        7: TexterifyManager.localisedString(key: .onboardingView(.eighthTileDescription)),
        8: TexterifyManager.localisedString(key: .onboardingView(.ninthTileDescription)),
        9: TexterifyManager.localisedString(key: .onboardingView(.tenthTileDescription))
    ]
    
    func getOnboardingTilesPhotos(completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        
        FirebaseStorageManager.downloadOnboardingImagesFromStorage { [weak self] result in
            self?.showLoadingModal = false
            switch result {
            case .success(let imagesModels):
                self?.onboardingTilesPhotosModels = imagesModels.sorted { $0.id < $1.id }
                completion(.success)
            case .failure(let error):
                self?.shouldShowOnboarding = false
                self?.shouldDismiss = true
                completion(.failure(error))
            }
        }
    }
}
