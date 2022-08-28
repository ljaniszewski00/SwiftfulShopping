//
//  WelcomeButtonsStyle.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022..
//

import SwiftUI

struct CustomButton: ButtonStyle {
    var buttonColor: Color = .accentColor
    var textColor: Color = .ssWhite
    var onlyStroke: Bool = false
    var strokeColor: Color = .accentColor
    var imageName: String = ""
    var imageColor: Color = .ssWhite
    var roundedRectangleShape: Bool = true
    var rightChevronNavigationImage: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 20) {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
            }
            configuration.label
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(textColor)
            if rightChevronNavigationImage {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(buttonColor == .accentColor ? .ssWhite : .accentColor)
            }
        }
        .padding(.horizontal)
        .frame(minWidth: 0, maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .frame(height: 54)
        .background {
            if roundedRectangleShape {
                RoundedRectangle(cornerRadius: 5)
                    .if(onlyStroke) {
                        $0
                            .stroke()
                            .foregroundColor(strokeColor)
                    }
            } else {
                Rectangle()
                    .if(onlyStroke) {
                        $0
                            .stroke()
                            .foregroundColor(strokeColor)
                    }
            }
        }
        .foregroundColor(buttonColor)
        .scaleEffect(configuration.isPressed ? 1.03 : 1.0)
        .onChange(of: configuration.isPressed) { _ in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}
