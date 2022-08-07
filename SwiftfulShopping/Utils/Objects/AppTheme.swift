//
//  AppTheme.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

class AppThemeViewModel: ObservableObject {
    @AppStorage("appThemeSetting") var appThemeSetting = Appearance.system
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
    var id: String { self.rawValue }
}

struct ThemeSettingsView: View{
    @AppStorage("appThemeSetting") var appThemeSetting = Appearance.system

    var body: some View {
        HStack {
            Picker("Appearance", selection: $appThemeSetting) {
                ForEach(Appearance.allCases) {appearance in
                    Text(appearance.rawValue.capitalized)
                        .tag(appearance)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
