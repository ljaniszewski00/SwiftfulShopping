//
//  ContentViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/08/2022.
//

import SwiftUI
import LocalAuthentication

class ContentViewModel: ObservableObject {
    @AppStorage("locked") var biometricLock: Bool = false
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @Published var unlocked: Bool = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Used to authenticate the user"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.unlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        } else {
            biometricLock = false
        }
    }
}
