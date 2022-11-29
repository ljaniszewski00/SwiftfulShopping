//
//  OnboardingViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/11/2022.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @AppStorage(AppStorageConstants.shouldShowOnboarding) var shouldShowOnboarding: Bool = true
}
