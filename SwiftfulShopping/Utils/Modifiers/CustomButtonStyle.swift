//
//  WelcomeButtonsStyle.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
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
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
            }
            configuration.label
                .foregroundColor(textColor)
                .padding()
        }
        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * buttonWidthMultiplier)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .if(onlyStroke) {
                    $0
                        .stroke()
                        .foregroundColor(strokeColor)
                }
                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * buttonWidthMultiplier)
        }
        .foregroundColor(buttonColor)
        
    }
}
