//
//  ErrorsManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import Foundation
import texterify_ios_sdk

final class ErrorManager: ObservableObject {
    private let errorsDescriptions: [ErrorType: String] = [
        .networkError:
            TexterifyManager.localisedString(key: .errors(.networkErrorDescription)),
        .productRecognizerError:
            TexterifyManager.localisedString(key: .errors(.productRecognizerErrorDescription)),
        .loginError:
            TexterifyManager.localisedString(key: .errors(.loginErrorDescription)),
        .registerError:
            TexterifyManager.localisedString(key: .errors(.registerErrorDescription)),
        .firstTimeLoginError:
            TexterifyManager.localisedString(key: .errors(.firstTimeLoginErrorDescription)),
        .emailPasswordSignInError:
            TexterifyManager.localisedString(key: .errors(.emailPasswordSignInErrorDescription)),
        .phoneSignInError:
            TexterifyManager.localisedString(key: .errors(.phoneSignInErrorDescription)),
        .googleSignInError:
            TexterifyManager.localisedString(key: .errors(.googleSignInErrorDescription)),
        .facebookSignInError:
            TexterifyManager.localisedString(key: .errors(.facebookSignInErrorDescription)),
        .githubSignInError:
            TexterifyManager.localisedString(key: .errors(.githubSignInErrorDescription)),
        .logoutError:
            TexterifyManager.localisedString(key: .errors(.logoutErrorDescription)),
        .changeEmailError:
            TexterifyManager.localisedString(key: .errors(.changeEmailErrorDescription)),
        .changePasswordError:
            TexterifyManager.localisedString(key: .errors(.changePasswordErrorDescription)),
        .deleteAccountError:
            TexterifyManager.localisedString(key: .errors(.deleteAccountErrorDescription)),
        .discountApplyError:
            TexterifyManager.localisedString(key: .errors(.discountApplyErrorDescription)),
        .orderCreateError:
            TexterifyManager.localisedString(key: .errors(.orderCreateErrorDescription)),
        .biometricRecognitionError:
            TexterifyManager.localisedString(key: .errors(.biometricRecognitionErrorDescription)),
        .applyProductRatingError:
            TexterifyManager.localisedString(key: .errors(.applyProductRatingErrorDescription)),
        .returnCreateError:
            TexterifyManager.localisedString(key: .errors(.returnCreateErrorDescription)),
        .createAddressError:
            TexterifyManager.localisedString(key: .errors(.createAddressErrorDescription)),
        .changeDefaultAddressError:
            TexterifyManager.localisedString(key: .errors(.changeDefaultAddressErrorDescription)),
        .changeDefaultPaymentMethodError:
            TexterifyManager.localisedString(key: .errors(.changeDefaultPaymentMethodErrorDescription)),
        .changePhotoError:
            TexterifyManager.localisedString(key: .errors(.changePhotoErrorDescription)),
        .dataFetchError:
            TexterifyManager.localisedString(key: .errors(.dataFetchErrorDescription)),
        .editPersonalInfoError:
            TexterifyManager.localisedString(key: .errors(.editPersonalInfoErrorDescription)),
        .unknownError:
            TexterifyManager.localisedString(key: .errors(.unknownErrorDescription))
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
    static let unknownError: CustomError = CustomError(errorType: .unknownError)
}
