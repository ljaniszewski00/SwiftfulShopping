//
//  AddToCartButton.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/10/2022.
//

import SwiftUI
import texterify_ios_sdk

struct AddToCartButton: View {
    let onAdd: () -> Void
    
    @State private var shouldPresentAddAnimation: Bool = false
    
    var body: some View {
        Button {
            withAnimation {
                shouldPresentAddAnimation = true
                onAdd()
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: shouldPresentAddAnimation ? "checkmark.circle.fill" : "cart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.ssWhite)
                Text(TexterifyManager.localisedString(key: .addToCartButton(.addToCartLabel)))
                    .font(.ssButton)
                    .foregroundColor(.ssWhite)
            }
            .padding(.all, 12)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 5)
            }
        }
        .onChange(of: shouldPresentAddAnimation) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        shouldPresentAddAnimation = false
                    }
                }
            }
        }
    }
}

struct AddToCartButton_Previews: PreviewProvider {
    static func voidFunc() {}
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                AddToCartButton(onAdd: voidFunc)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
