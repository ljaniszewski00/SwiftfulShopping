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
            HStack(spacing: -10) {
                LottieView(name: "add_to_cart",
                           loopMode: .playOnce,
                           contentMode: .scaleAspectFit,
                           shouldPlay: $shouldPresentAddAnimation)
                .frame(minWidth: 50, maxHeight: 40)
                
                Text(TexterifyManager.localisedString(key: .addToCartButton(.addToCartLabel)))
                    .font(.ssButton)
                    .foregroundColor(.ssWhite)
                    .padding(.all, 10)
            }
            .padding(.vertical, 5)
            .background {
                RoundedRectangle(cornerRadius: 5)
            }
            .fixedSize(horizontal: true, vertical: false)
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
