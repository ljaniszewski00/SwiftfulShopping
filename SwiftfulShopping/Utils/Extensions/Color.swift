//
//  HexColorInit.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

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
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alfa, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alfa, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alfa, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alfa, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alfa, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alfa) / 255
        )
    }
}

extension Color {
    static let ssDefaultAccentColor: Color = Color(hex: "#4EAC91")
    
    static let ssWhite: Color = Color(hex: "#FFFFFF")
    static let ssBlue: Color = Color(hex: "#058AD7")
    static let ssDarkBlue: Color = Color(hex: "#046095")
    static let ssOrange: Color = Color(hex: "#FF5614")
    static let ssPink: Color = Color(hex: "#FDA6A6")
    static let ssGray: Color = Color(hex: "#B9CCDB")
    static let ssDarkGray: Color = Color(hex: "#89A3B6")
    static let ssBlack: Color = Color(hex: "#484C55")
    static let ssDisabled: Color = Color(hex: "#D0DAE2")

    static let colorRegularText: Color = Color.ssBlack
    static let colorDimmedText: Color = Color(hex: "#9DAEBA")

    static let mainText: Color = Color(hex: "#121517")
    static let windowBackground: Color = Color(hex: "#F4F6F8")
    static let loaderBackground: Color = Color(hex: "#60ffffff")
    
    static let errorModalStroke: Color = Color(hex: "#FC676B")
    static let errorModalInside: Color = Color(hex: "#FCCACF")
}
