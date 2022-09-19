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
        .googleSignInError: 4,
        .facebookSignInError: 5,
        .githubSignInError: 6,
        .registerError: 7,
        .discountApplyError: 8,
        .orderCreateError: 9,
        .biometricRecognitionError: 10,
        .changeEmailError: 11,
        .changePasswordError: 12,
        .deleteAccountError: 13,
        .unknown: 0
    ]
    
    private static let errorDescriptionSuffix: String = "Please try again later."

    private let errorsDescriptions: [ErrorType: String] = [
        .networkError: "No internet connection. Some functions will be unavailable.",
        .productRecognizerError: "Error occured while recognizing your product. \(errorDescriptionSuffix)",
        .loginError: "Error occured while trying to log in. \(errorDescriptionSuffix)",
        .googleSignInError: "Error occured while trying to log in via Google. \(errorDescriptionSuffix)",
        .facebookSignInError: "Error occured while trying to log in via Facebook. \(errorDescriptionSuffix)",
        .githubSignInError: "Error occured while trying to log in via GitHub. \(errorDescriptionSuffix)",
        .registerError: "Error occured while trying to register. \(errorDescriptionSuffix)",
        .discountApplyError: "Error applying discount code. \(errorDescriptionSuffix)",
        .orderCreateError: "Error creating your order. \(errorDescriptionSuffix)",
        .biometricRecognitionError: "Error authenticating using biometry. Please try again.",
        .changeEmailError: "Error occured while trying to change the email. \(errorDescriptionSuffix)",
        .changePasswordError: "Error occured while trying to change the password. \(errorDescriptionSuffix)",
        .deleteAccountError: "Error occured while trying delete the account. \(errorDescriptionSuffix)",
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
