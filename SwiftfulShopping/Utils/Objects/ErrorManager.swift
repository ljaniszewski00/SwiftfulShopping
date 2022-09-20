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
        .emailPasswordSignInError: 4,
        .phoneSignInError: 5,
        .googleSignInError: 6,
        .facebookSignInError: 7,
        .githubSignInError: 8,
        .registerError: 9,
        .discountApplyError: 10,
        .orderCreateError: 11,
        .biometricRecognitionError: 12,
        .changeEmailError: 13,
        .changePasswordError: 14,
        .deleteAccountError: 15,
        .unknown: 0
    ]
    
    private static let errorDescriptionSuffix: String = "Please try again later."

    private let errorsDescriptions: [ErrorType: String] = [
        .networkError: "No internet connection. Some functions will be unavailable.",
        .productRecognizerError: "Error occured while recognizing your product. \(errorDescriptionSuffix)",
        .loginError: "Error occured while trying to log in. \(errorDescriptionSuffix)",
        .emailPasswordSignInError: "Error occured while trying to log in with email and password. \(errorDescriptionSuffix)",
        .phoneSignInError: "Error occured while trying to log in with phone number. \(errorDescriptionSuffix)",
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
                                          errorDescription: errorDescription + "\n\n" + additionalErrorDescription)
                
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
