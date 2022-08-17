//
//  ErrorsManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import Foundation

final class ErrorManager: ObservableObject {
    private let errorsCodes: [ErrorType: Int] = [
        .networkError: 1,
        .productRecognizerError: 2,
        .unknown: 0
    ]

    private let errorsDescriptions: [ErrorType: String] = [
        .networkError: "No internet connection. Some functions will be unavailable.",
        .productRecognizerError: "Error occured while recognizing your product. Please try again later.",
        .unknown: ""
    ]
    
    @Published var showErrorModal: Bool = false
    @Published var customError: CustomError?
    
    static let shared: ErrorManager = {
        ErrorManager()
    }()
    
    func generateCustomError(errorType: ErrorType, additionalErrorDescription: String? = nil) {
        if let additionalErrorDescription = additionalErrorDescription {
            customError = CustomError(errorType: errorType, errorCode: errorsCodes[errorType]!, errorDescription: errorsDescriptions[errorType]! + additionalErrorDescription)
            
        } else {
            customError = CustomError(errorType: errorType, errorCode: errorsCodes[errorType]!, errorDescription: errorsDescriptions[errorType]!)
        }
        showErrorModal = true
    }
}

extension ErrorManager {
    static let unknownError: CustomError = CustomError(errorType: .unknown, errorCode: 0)
}
