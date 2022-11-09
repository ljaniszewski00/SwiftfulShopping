//
//  ErrorType.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/09/2022.
//

import Foundation
import texterify_ios_sdk

enum ErrorType: String {
    case networkError
    case productRecognizerError
    case loginError
    case registerError
    case firstTimeLoginError
    case emailPasswordSignInError
    case phoneSignInError
    case googleSignInError
    case facebookSignInError
    case githubSignInError
    case logoutError
    case changeEmailError
    case changePasswordError
    case deleteAccountError
    case discountApplyError
    case orderCreateError
    case biometricRecognitionError
    case applyProductRatingError
    case returnCreateError
    case createAddressError
    case changeDefaultAddressError
    case changeDefaultPaymentMethodError
    case changePhotoError
    case dataFetchError
    case editPersonalInfoError
    case addProductToComparison
    case unknownError
    
    var rawValue: String {
        switch self {
        case .networkError:
            return TexterifyManager.localisedString(key: .errors(.networkError))
        case .productRecognizerError:
            return TexterifyManager.localisedString(key: .errors(.productRecognizerError))
        case .loginError:
            return TexterifyManager.localisedString(key: .errors(.loginError))
        case .registerError:
            return TexterifyManager.localisedString(key: .errors(.registerError))
        case .firstTimeLoginError:
            return TexterifyManager.localisedString(key: .errors(.firstTimeLoginError))
        case .emailPasswordSignInError:
            return TexterifyManager.localisedString(key: .errors(.emailPasswordSignInError))
        case .phoneSignInError:
            return TexterifyManager.localisedString(key: .errors(.phoneSignInError))
        case .googleSignInError:
            return TexterifyManager.localisedString(key: .errors(.googleSignInError))
        case .facebookSignInError:
            return TexterifyManager.localisedString(key: .errors(.facebookSignInError))
        case .githubSignInError:
            return TexterifyManager.localisedString(key: .errors(.githubSignInError))
        case .logoutError:
            return TexterifyManager.localisedString(key: .errors(.logoutError))
        case .changeEmailError:
            return TexterifyManager.localisedString(key: .errors(.changeEmailError))
        case .changePasswordError:
            return TexterifyManager.localisedString(key: .errors(.changePasswordError))
        case .deleteAccountError:
            return TexterifyManager.localisedString(key: .errors(.deleteAccountError))
        case .discountApplyError:
            return TexterifyManager.localisedString(key: .errors(.discountApplyError))
        case .orderCreateError:
            return TexterifyManager.localisedString(key: .errors(.orderCreateError))
        case .biometricRecognitionError:
            return TexterifyManager.localisedString(key: .errors(.biometricRecognitionError))
        case .applyProductRatingError:
            return TexterifyManager.localisedString(key: .errors(.applyProductRatingError))
        case .returnCreateError:
            return TexterifyManager.localisedString(key: .errors(.returnCreateError))
        case .createAddressError:
            return TexterifyManager.localisedString(key: .errors(.createAddressError))
        case .changeDefaultAddressError:
            return TexterifyManager.localisedString(key: .errors(.changeDefaultAddressError))
        case .changeDefaultPaymentMethodError:
            return TexterifyManager.localisedString(key: .errors(.changeDefaultPaymentMethodError))
        case .changePhotoError:
            return TexterifyManager.localisedString(key: .errors(.changePhotoError))
        case .dataFetchError:
            return TexterifyManager.localisedString(key: .errors(.dataFetchError))
        case .editPersonalInfoError:
            return TexterifyManager.localisedString(key: .errors(.editPersonalInfoError))
        case .addProductToComparison:
            return TexterifyManager.localisedString(key: .errors(.addProductToComparison))
        case .unknownError:
            return TexterifyManager.localisedString(key: .errors(.unknownError))
        }
    }
}
