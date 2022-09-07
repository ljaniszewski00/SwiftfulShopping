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
    case registerError = "Register Error"
    case discountApplyError = "Discount Apply Error"
    case orderCreateError = "Order Create Error"
    case unknown = "Unknown Error"
}
