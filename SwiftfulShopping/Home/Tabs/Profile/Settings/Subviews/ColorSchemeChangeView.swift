//
//  ColorSchemeChangeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct ColorSchemeChangeView: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        List {
            ForEach(Appearance.allCases, id: \.self) { appearance in
                HStack {
                    Text(appearance.rawValue.capitalized)
                    
                    Spacer()
                    
                    if appearance == settingsViewModel.appThemeSetting {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        settingsViewModel.appThemeSetting = appearance
                    }
                }
            }
        }
        .navigationTitle("Choose Color Theme")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ColorSchemeChangeView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsViewModel = SettingsViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ColorSchemeChangeView()
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
