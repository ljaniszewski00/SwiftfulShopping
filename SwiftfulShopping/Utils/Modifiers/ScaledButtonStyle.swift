//
//  ScaledButtonStyle.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 22/07/2022.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
