//
//  ErrorsManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import Foundation

final class ErrorManager: ObservableObject {
    private static let errorDescriptionSuffix: String = "Please try again later."

    private let errorsDescriptions: [ErrorType: String] = [
        .networkError: "No internet connection. Some functions will be unavailable.",
        .productRecognizerError: "Error occured while recognizing your product. \(errorDescriptionSuffix)",
        .loginError: "Error occured while trying to log in. \(errorDescriptionSuffix)",
        .registerError: "Error occured while trying to register. \(errorDescriptionSuffix)",
        .firstTimeLoginError: "Error occured while trying to log in for the first time. \(errorDescriptionSuffix)",
        .emailPasswordSignInError: "Error occured while trying to log in with email and password. \(errorDescriptionSuffix)",
        .phoneSignInError: "Error occured while trying to log in with phone number. \(errorDescriptionSuffix)",
        .googleSignInError: "Error occured while trying to log in via Google. \(errorDescriptionSuffix)",
        .facebookSignInError: "Error occured while trying to log in via Facebook. \(errorDescriptionSuffix)",
        .githubSignInError: "Error occured while trying to log in via GitHub. \(errorDescriptionSuffix)",
        .discountApplyError: "Error applying discount code. \(errorDescriptionSuffix)",
        .orderCreateError: "Error creating your order. \(errorDescriptionSuffix)",
        .biometricRecognitionError: "Error authenticating using biometry. Please try again.",
        .changeEmailError: "Error occured while trying to change the email. \(errorDescriptionSuffix)",
        .changePasswordError: "Error occured while trying to change the password. \(errorDescriptionSuffix)",
        .deleteAccountError: "Error occured while trying delete the account. \(errorDescriptionSuffix)",
        .databaseManagerEncodingError: "Error encoding requestes data. \(errorDescriptionSuffix)",
        .unknown: ""
    ]
    
    @Published var showErrorModal: Bool = false
    @Published var customError: CustomError?
    
    static let shared: ErrorManager = {
        ErrorManager()
    }()
    
    func generateCustomError(errorType: ErrorType, additionalErrorDescription: String? = nil) {
        if let errorDescription = errorsDescriptions[errorType] {
            if let additionalErrorDescription = additionalErrorDescription {
                customError = CustomError(errorType: errorType,
                                          errorDescription: errorDescription + "\n\n" + additionalErrorDescription)
                
            } else {
                customError = CustomError(errorType: errorType,
                                          errorDescription: errorDescription)
            }
            showErrorModal = true
        }
    }
}

extension ErrorManager {
    static let unknownError: CustomError = CustomError(errorType: .unknown)
}
