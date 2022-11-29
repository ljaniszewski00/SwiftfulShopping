//
//  StartViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import SwiftUI
import LocalAuthentication

class StartViewModel: ObservableObject {
    @AppStorage(AppStorageConstants.locked) var biometricLock: Bool = false
    @AppStorage(AppStorageConstants.shouldShowOnboarding) var shouldShowOnboarding: Bool = true
    
    @Published var unlocked: Bool = false
    @Published var authenticationError: Error?
    
    @Published var dataFetched: Bool = false
    
    @Published var presentRegisterView: Bool = false
    
    var unlockedBiometric: Bool {
        unlocked || !biometricLock
    }
    
    var canPresentHomeView: Bool {
        unlockedBiometric && dataFetched && !shouldShowOnboarding
    }
    
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
                    self.unlocked = success
                    self.authenticationError = authenticationError
                }
            }
        } else {
            unlocked = true
            biometricLock = false
        }
    }
}
