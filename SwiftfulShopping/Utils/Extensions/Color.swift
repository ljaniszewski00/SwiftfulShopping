//
//  HexColorInit.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}

extension Color {
    ///
    /// Example of use:
    ///
    ///     Text("Hello World!")
    ///         .background(Color(hex: 0xf5bc53))
    ///
    ///     Text("Hello World!")
    ///         .background(Color(hex: 0xf5bc53, opacity: 0.8)
    ///
    
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color {
    static let backgroundColor = Color("BackgroundColor")
}
