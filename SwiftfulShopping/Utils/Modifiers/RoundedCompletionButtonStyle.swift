//
//  RoundedCompletionButtonStyle.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI

struct RoundedCompletionButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var buttonColor: Color = .accentColor
    var onlyStroke: Bool = true
    var strokeColor: Color = .accentColor
    var imageName: String = ""
    var imageColor: Color = .white
    var actionCompleted: Bool = false
    var actionCompletedText: String = ""
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
            }

            if actionCompleted {
                Text(actionCompletedText)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .padding()
            } else {
                configuration.label
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .padding()
            }
            
            Image(systemName: actionCompleted ? "checkmark" : "chevron.right")
                .foregroundColor(actionCompleted ? .accentColor : (colorScheme == .light ? .black : .white))
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .if(onlyStroke) {
                    $0
                        .stroke(lineWidth: 2)
                        .foregroundColor(strokeColor)
                }
        }
        .foregroundColor(buttonColor)
    }
}
