//
//  ErrorType.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/09/2022.
//

import Foundation

enum ErrorType: String {
    case networkError = "Network Error"
    case productRecognizerError = "Product Recognizer Error"
    case loginError = "Login Error"
    case emailPasswordSignInError = "Email and Password Sign In Error"
    case phoneSignInError = "Phone Sign In Error"
    case googleSignInError = "Google Sign In Error"
    case facebookSignInError = "Facebook Sign In Error"
    case githubSignInError = "Github Sign In Error"
    case logoutError = "Logout Error"
    case changeEmailError = "Change Email Error"
    case changePasswordError = "Change Password Error"
    case deleteAccountError = "Delete Account Error"
    case registerError = "Register Error"
    case discountApplyError = "Discount Apply Error"
    case orderCreateError = "Order Create Error"
    case biometricRecognitionError = "Biometric Recognition Error"
    
    case unknown = "Unknown Error"
}
