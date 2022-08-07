//
//  SettingsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("locked") var biometricLock: Bool = false
    @AppStorage("notifications") var notifications: Bool = true
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @AppStorage("appThemeSetting") var appThemeSetting = Appearance.system
    
    @Published var shouldPresentAccentColorChangeView: Bool = false
    @Published var shouldPresentColorSchemeChangeView: Bool = false
    
    @Published var shouldPresentChangeEmailView: Bool = false
    @Published var shouldPresentChangePasswordView: Bool = false
    @Published var shouldPresentDeleteAccountView: Bool = false
    
    @Published var shouldPresentTermsAndConditionsView: Bool = false
}
