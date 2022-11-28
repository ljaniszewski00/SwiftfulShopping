//
//  AppTheme.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI
import texterify_ios_sdk

class AppThemeViewModel: ObservableObject {
    @AppStorage(AppStorageConstants.appThemeSetting) var appThemeSetting = Appearance.system
}

struct DarkModeViewModifier: ViewModifier {
    @ObservedObject var appThemeViewModel: AppThemeViewModel = AppThemeViewModel()

    public func body(content: Content) -> some View {
        content
            .preferredColorScheme((appThemeViewModel.appThemeSetting == .system) ? .none : appThemeViewModel.appThemeSetting == .light ? .light : .dark)
    }
}

enum Appearance: String, CaseIterable, Identifiable  {
    case system
    case light
    case dark
    
    static var allCases: [Appearance] = [
        .system, .light, .dark
    ]
    
    var id: String { self.rawValue }
    
    var localizedValue: String {
        switch self {
        case .system:
            return TexterifyManager.localisedString(key: .appearance(.system))
        case .light:
            return TexterifyManager.localisedString(key: .appearance(.light))
        case .dark:
            return TexterifyManager.localisedString(key: .appearance(.dark))
        }
    }
    
    var rawValue: String {
        switch self {
        case .system:
            return "system"
        case .light:
            return "light"
        case .dark:
            return "dark"
        }
    }
}
