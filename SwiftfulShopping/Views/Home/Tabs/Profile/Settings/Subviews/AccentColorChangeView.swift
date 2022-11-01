//
//  AccentColorChangeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct AccentColorChangeView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        VStack {
            HStack {
                Text(TexterifyManager.localisedString(key: .accentColorChangeView(.adjustThemeColor)))
                    .font(.ssTitle1)
                    .bold()
                    .foregroundColor(.accentColor)
                    
                Spacer()
            }
            .padding(.bottom)
            
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]) {
                ForEach(accentColorManager.availableColors, id: \.self) { color in
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .foregroundColor(Color(uiColor: color.rawValue))
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                accentColorManager.saveCustomColor(color: color)
                            }
                        if !accentColorManager.ownColorSet && accentColorManager.accentColor == color {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
            }
            .padding(.bottom, 50)
            
            HStack {
                ColorPicker(selection: $accentColorManager.ownColor) {
                    Text(TexterifyManager.localisedString(key: .accentColorChangeView(.addCustomPickerText)))
                        .font(.ssTitle2)
                }
                .onChange(of: accentColorManager.ownColor) { _ in
                    accentColorManager.saveOwnColor()
                }
                
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .foregroundColor(accentColorManager.ownColor)
                        .frame(width: 80, height: 80)
                    if accentColorManager.ownColorSet {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .onTapGesture {
                    accentColorManager.saveOwnColor()
                }
                .padding(.leading, 20)
                .padding(.trailing, 100)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(TexterifyManager.localisedString(key: .accentColorChangeView(.navigationTitle)))
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct AccentColorChangeView_Previews: PreviewProvider {
    static var previews: some View {
        let accentColorManager = AccentColorManager()
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                AccentColorChangeView()
                    .environmentObject(accentColorManager)
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
