//
//  AddToCartButton.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/10/2022.
//

import SwiftUI

struct AddToCartButton: View {
    @State private var shouldPresentAddAnimation: Bool = false
    var onAdd: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                shouldPresentAddAnimation = true
                onAdd()
            }
        } label: {
            HStack(spacing: -15) {
                LottieView(name: "add_to_cart",
                           loopMode: .playOnce,
                           contentMode: .scaleAspectFill,
                           shouldPlay: shouldPresentAddAnimation)
                .frame(minWidth: 60, maxHeight: 50)
                
                Text("Add to Cart")
                    .font(.ssButton)
                    .foregroundColor(.ssWhite)
                    .padding(.all, 10)
            }
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
