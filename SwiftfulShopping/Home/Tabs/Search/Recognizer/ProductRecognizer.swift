//
//  ProductRecognizer.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/08/2022.
//

import CoreML
import Vision
import CoreImage
import AVKit

class ProductRecognizer: ObservableObject {
    @Published var sourceForImageRecognition: SourceForImageRecognition = .camera
    
    @Published var pixelBuffer: CVPixelBuffer?
    @Published var imageForRecognition = UIImage()
    @Published var recognitionResult: String?
    
    @Published var shouldPresentSheetWithResults: Bool = false
    @Published var shouldPresentRecognizingAnimation: Bool = false
    
    func recognizeProduct(pixelBuffer: CVPixelBuffer?, errorManager: ErrorManager, completion: @escaping (() -> ())) {
        self.pixelBuffer = pixelBuffer
        if let request = buildRecognitionRequest(errorManager: errorManager) {
            switch sourceForImageRecognition {
            case .camera:
                recognizeProductFromCamera(request: request, errorManager: errorManager)
            case .photoLibrary:
                recognizeProductFromPhotoLibrary(request: request, errorManager: errorManager)
            }
            let result = prepareRecognitionResults(request: request, errorManager: errorManager)
            self.recognitionResult = result
            completion()
        }
    }
    
    func getFormattedResults() -> [String] {
        var resultsSplitted: Set<String> = []
        if let recognitionResult = recognitionResult {
            let replaced = recognitionResult.replacingOccurrences(of: ",", with: "")
            let splitted = replaced.split(separator: " ")
            for split in splitted {
                resultsSplitted.insert(String(split))
            }
        }
        return Array(resultsSplitted)
    }
    
    private func buildRecognitionRequest(errorManager: ErrorManager) -> VNCoreMLRequest? {
        if let model = try? VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model) {
            return VNCoreMLRequest(model: model) { [weak self] request, error in
                if let error = error {
                    self?.generateError(errorManager: errorManager,
                                  additionalErrorDescription: error.localizedDescription)
                }
            }
        } else {
            generateError(errorManager: errorManager,
                          additionalErrorDescription: "Error getting recognition model")
            return nil
        }
    }
    
    private func recognizeProductFromCamera(request: VNCoreMLRequest, errorManager: ErrorManager) {
        if let cvPixelBuffer = self.pixelBuffer {
            do {
                try VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:]).perform([request])
            } catch(let error) {
                generateError(errorManager: errorManager,
                              additionalErrorDescription: error.localizedDescription)
            }
        } else {
            generateError(errorManager: errorManager,
                          additionalErrorDescription: "Error processing Pixel Buffer")
        }
    }
    
    private func recognizeProductFromPhotoLibrary(request: VNCoreMLRequest, errorManager: ErrorManager) {
        if let ciImage = CIImage(image: imageForRecognition) {
            do {
                try VNImageRequestHandler(ciImage: ciImage, options: [:]).perform([request])
            } catch(let error) {
                generateError(errorManager: errorManager,
                              additionalErrorDescription: error.localizedDescription)
            }
        } else {
            generateError(errorManager: errorManager,
                          additionalErrorDescription: "Error processing CIImage")
        }
    }
    
    private func prepareRecognitionResults(request: VNCoreMLRequest, errorManager: ErrorManager) -> String? {
        if let firstResult = request.results?[0] as? VNClassificationObservation,
           let secondResult = request.results?[1] as? VNClassificationObservation {
            return firstResult.identifier + ", " + secondResult.identifier
        } else {
            generateError(errorManager: errorManager,
                          additionalErrorDescription: "Error getting first result from results")
            return nil
        }
    }
    
    private func generateError(errorManager: ErrorManager, additionalErrorDescription: String?) {
        errorManager.generateCustomError(errorType: .productRecognizerError,
                                         additionalErrorDescription: additionalErrorDescription)
    }
}
