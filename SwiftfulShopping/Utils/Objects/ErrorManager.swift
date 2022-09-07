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
        .loginError: 3,
        .registerError: 4,
        .discountApplyError: 5,
        .orderCreateError: 6,
        .unknown: 0
    ]
    
    private static let errorDescriptionSuffix: String = "Please try again later."

    private let errorsDescriptions: [ErrorType: String] = [
        .networkError: "No internet connection. Some functions will be unavailable.",
        .productRecognizerError: "Error occured while recognizing your product. \(errorDescriptionSuffix)",
        .loginError: "Error occured while trying to log in. \(errorDescriptionSuffix)",
        .registerError: "Error occured while trying to register. \(errorDescriptionSuffix)",
        .discountApplyError: "Error applying discount code. \(errorDescriptionSuffix)",
        .orderCreateError: "Error creating your order. \(errorDescriptionSuffix)",
        .unknown: ""
    ]
    
    @Published var showErrorModal: Bool = false
    @Published var customError: CustomError?
    
    static let shared: ErrorManager = {
        ErrorManager()
    }()
    
    func generateCustomError(errorType: ErrorType, additionalErrorDescription: String? = nil) {
        if let errorCode = errorsCodes[errorType], let errorDescription = errorsDescriptions[errorType] {
            if let additionalErrorDescription = additionalErrorDescription {
                customError = CustomError(errorType: errorType,
                                          errorCode: errorCode,
                                          errorDescription: errorDescription + "\n" + additionalErrorDescription)
                
            } else {
                customError = CustomError(errorType: errorType,
                                          errorCode: errorCode,
                                          errorDescription: errorDescription)
            }
            showErrorModal = true
        }
    }
}

extension ErrorManager {
    static let unknownError: CustomError = CustomError(errorType: .unknown,
                                                       errorCode: 0)
}
