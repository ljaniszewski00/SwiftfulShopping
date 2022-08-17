//
//  SearchViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI
import CoreML
import Vision
import CoreImage

class SearchViewModel: ObservableObject {
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    @Published var shouldPresentProductRecognizerView: Bool = false
    @Published var shouldPresentImagePicker: Bool = false
    @Published var oldImageForRecognition: UIImage?
    @Published var imageForRecognition = UIImage()
    @Published var recognitionResult: String?
    
    @Published var trendingSearchesFullList: [String] = []
    var trendingSearches: [String] {
        Array(trendingSearchesFullList.prefix(4))
    }
    @Published var shouldPresentAllTrendingSearches: Bool = false
    
    @Published var recentSearchesFullList: [String] = []
    var recentSearches: [String] {
        Array(recentSearchesFullList.prefix(4))
    }
    @Published var shouldPresentAllRecentSearches: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    func onAppear() {
        fetchTrendingSearches()
        fetchRecentSearches()
    }
    
    func fetchTrendingSearches() {
        self.trendingSearchesFullList = ["iPhone", "iPad", "MacBook", "Apple Watch", "Home Pod", "Apple VR", "Apple Car"]
    }
    
    func fetchRecentSearches() {
        self.recentSearchesFullList = UserDefaults.standard.array(forKey: "recentSearches") as? [String] ?? []
    }
    
    func removeRecentSearches() {
        recentSearchesFullList.removeAll()
        UserDefaults.standard.set(recentSearchesFullList, forKey: "recentSearches")
    }
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
    
    func addToRecentSearches(searchText: String) {
        if !recentSearchesFullList.contains(searchText) {
            recentSearchesFullList.append(searchText)
            UserDefaults.standard.set(recentSearchesFullList, forKey: "recentSearches")
        }
    }
    
    func uploadNewImageForRecognition() {
        if let oldImageForRecognition = oldImageForRecognition {
            if !imageForRecognition.isEqual(oldImageForRecognition) {
                self.oldImageForRecognition = imageForRecognition
            }
        } else {
            oldImageForRecognition = imageForRecognition
        }
    }
    
    func recognizeImage(errorManager: ErrorManager) {
        if let ciImage = CIImage(image: imageForRecognition) {
            if let model = try? VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model) {
                let request = VNCoreMLRequest(model: model)

                let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

                try? handler.perform([request])

                if let firstResult = request.results?.first as? VNClassificationObservation {
                    self.recognitionResult = firstResult.identifier
                } else {
                    generateError(errorManager: errorManager,
                                  additionalErrorDescription: "Error getting first result from results")
                }
            } else {
                generateError(errorManager: errorManager,
                              additionalErrorDescription: "Error getting recognition model")
            }
        } else {
            generateError(errorManager: errorManager,
                          additionalErrorDescription: "Error processing CIImage")
        }
    }
    
    func generateError(errorManager: ErrorManager, additionalErrorDescription: String?) {
        errorManager.generateCustomError(errorType: .productRecognizerError,
                                         additionalErrorDescription: additionalErrorDescription)
    }
}
