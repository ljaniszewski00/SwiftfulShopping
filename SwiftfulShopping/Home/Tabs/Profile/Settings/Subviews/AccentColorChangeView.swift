//
//  AccentColorChangeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct AccentColorChangeView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Adjust Theme Color")
                    .font(.largeTitle)
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
                    Text("Add Custom")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
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
