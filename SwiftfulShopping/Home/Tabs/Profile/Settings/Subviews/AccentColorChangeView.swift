//
//  AccentColorChangeView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct AccentColorChangeView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                Text("Adjust Theme Color")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
                    
                Spacer()
            }
            .padding()
            .padding(.bottom)
            
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]) {
                ForEach(accentColorManager.availableColors, id: \.self) { color in
                    if accentColorManager.accentColor == color {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .foregroundColor(Color(uiColor: color.rawValue))
                                .frame(width: 80, height: 80)
                                .onTapGesture {
                                    accentColorManager.accentColor = color
                                }
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    } else {
                        Circle()
                            .foregroundColor(Color(uiColor: color.rawValue))
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                withAnimation {
                                    accentColorManager.accentColor = color
                                }
                            }
                    }
                }
            }
        }
    }
}

struct AccentColorChangeView_Previews: PreviewProvider {
    static var previews: some View {
        let accentColorManager = AccentColorManager()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                AccentColorChangeView()
                    .environmentObject(accentColorManager)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
