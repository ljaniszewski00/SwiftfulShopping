//
//  WelcomeButtonsStyle.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022..
//

import SwiftUI

struct CustomButton: ButtonStyle {
    var buttonColor: Color = .accentColor
    var textColor: Color = .white
    var onlyStroke: Bool = false
    var strokeColor: Color = .accentColor
    var buttonWidthMultiplier: CGFloat = 0.9
    var imageName: String = ""
    var imageColor: Color = .white
    var roundedRectangleShape: Bool = true
    var rightChevronNavigationImage: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
            }
            configuration.label
                .foregroundColor(textColor)
                .padding()
            if rightChevronNavigationImage {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(buttonColor == .accentColor ? .white : .accentColor)
            }
        }
        .padding(.horizontal)
        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * buttonWidthMultiplier)
        .background {
            Group {
                if roundedRectangleShape {
                    RoundedRectangle(cornerRadius: 5)
                        .if(onlyStroke) {
                            $0
                                .stroke()
                                .foregroundColor(strokeColor)
                        }
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * buttonWidthMultiplier)
                } else {
                    Rectangle()
                        .if(onlyStroke) {
                            $0
                                .stroke()
                                .foregroundColor(strokeColor)
                        }
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * buttonWidthMultiplier)
                }
            }
        }
        .foregroundColor(buttonColor)
        .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
    }
}
