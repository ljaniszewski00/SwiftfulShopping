//
//  DoubleToggle.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 27/08/2022.
//

import SwiftUI

struct SingleSelectionToggle: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selection: Bool
    
    var firstLabel: String = "Yes"
    var secondLabel: String = "No"
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                selection.toggle()
            }, label: {
                HStack(spacing: 20) {
                    Image(systemName: selection ?
                          "checkmark.square.fill" : "square")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: 22, height: 22)
                    
                    Text(firstLabel)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .light ? .black : .white)
                }
            })
            
            Button(action: {
                selection.toggle()
            }, label: {
                HStack(spacing: 20) {
                    Image(systemName: !selection ?
                          "checkmark.square.fill" : "square")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: 22, height: 22)
                    
                    Text(secondLabel)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .light ? .black : .white)
                }
            })
        }
    }
}

struct SingleSelectionToggle_Previews: PreviewProvider {
    @State static var firstOption: Bool = true
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SingleSelectionToggle(selection: $firstOption)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
