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
    
    private let MLModels: [MLModel?] = [try? Resnet50(configuration: MLModelConfiguration()).model,
                                        try? MobileNetV2(configuration: MLModelConfiguration()).model,
                                        try? SqueezeNet(configuration: MLModelConfiguration()).model]
    private let maxRecognitionsNumberPerModel: Int = 3
    
    func recognizeProduct(pixelBuffer: CVPixelBuffer?, errorManager: ErrorManager, completion: @escaping (() -> ())) {
        self.pixelBuffer = pixelBuffer
        if let requests = buildRecognitionRequests(errorManager: errorManager) {
            switch sourceForImageRecognition {
            case .camera:
                recognizeProductFromCamera(requests: requests, errorManager: errorManager)
            case .photoLibrary:
                if let firstRequest = requests.first {
                    recognizeProductFromPhotoLibrary(request: firstRequest, errorManager: errorManager)
                }
            }
            let result = prepareRecognitionResults(requests: requests, errorManager: errorManager)
            self.recognitionResult = result
//            print(self.recognitionResult)
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
    
    private func buildRecognitionRequests(errorManager: ErrorManager) -> [VNCoreMLRequest]? {
        var requests: [VNCoreMLRequest]?
        for MLModel in MLModels {
            if let MLModel = MLModel, let model = try? VNCoreMLModel(for: MLModel) {
                if requests == nil {
                    requests = []
                }
                let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                    if let error = error {
                        self?.generateError(errorManager: errorManager,
                                            additionalErrorDescription: error.localizedDescription)
                    }
                }
                requests!.append(request)
            } else {
                generateError(errorManager: errorManager,
                              additionalErrorDescription: "Error getting recognition model")
            }
        }
        return requests
    }
    
    private func recognizeProductFromCamera(requests: [VNCoreMLRequest], errorManager: ErrorManager) {
        if let cvPixelBuffer = self.pixelBuffer {
            do {
                try VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:]).perform(requests)
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
    
    private func prepareRecognitionResults(requests: [VNCoreMLRequest], errorManager: ErrorManager) -> String? {
        var resultString: String?
        for request in requests {
            if let results = request.results {
                var iterationEndIndex = maxRecognitionsNumberPerModel
                if results.count < 3 {
                    iterationEndIndex = results.endIndex
                }
                
                if resultString == nil {
                    resultString = ""
                }
                
                for resultNumber in 0...iterationEndIndex {
                    let observation = results[resultNumber] as? VNClassificationObservation
                    if resultString == nil {
                        resultString = ""
                    }
                    resultString! += "\(String(describing: observation?.identifier)), "
                }
            } else {
                generateError(errorManager: errorManager,
                              additionalErrorDescription: "Error processing recognition results")
            }
        }
        return resultString
    }
    
    private func generateError(errorManager: ErrorManager, additionalErrorDescription: String?) {
        errorManager.generateCustomError(errorType: .productRecognizerError,
                                         additionalErrorDescription: additionalErrorDescription)
    }
}
