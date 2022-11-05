//
//  SignInMethod.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/09/2022.
//

import Foundation

enum SignInMethod: String {
    case emailPassword = "Email and Password"
    case google = "Google"
    case facebook = "Facebook"
    case github = "Github"
    
    var decodeValue: String {
        switch self {
        case .emailPassword:
            return "Email and Password"
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        case .github:
            return "GitHub"
        }
    }
}

extension SignInMethod {
    static var allCases: [SignInMethod] {
        return [.emailPassword, .google, .facebook, .github]
    }
}

extension SignInMethod {
    static func withLabel(_ label: String) -> SignInMethod? {
        return self.allCases.first { "\($0.decodeValue)" == label }
    }
}
