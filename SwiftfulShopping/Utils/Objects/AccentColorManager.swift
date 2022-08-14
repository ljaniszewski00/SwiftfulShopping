//
//  AccentColorManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

class AccentColorManager: ObservableObject {
    @Published var accentColor: AccentColors = .swiftfulShoppingDefaultGreen
    @Published var ownColor: Color = Color.accentColor
    @Published var ownColorSet: Bool = false
    
    var availableColors: [AccentColors] = [.swiftfulShoppingDefaultGreen, .blue, .red, .green, .purple, .yellow]
    
    func fetchColors() {
        ownColorSet = UserDefaults.standard.bool(forKey: "ownColorSet")
        
        let fetchedOwnColorRGB = UserDefaults.standard.integer(forKey: "ownColorRGB")
        self.ownColor = Color(uiColor: UIColor(rgb: fetchedOwnColorRGB))
        
        if !ownColorSet {
            let fetchedAccentColorRGB = UserDefaults.standard.integer(forKey: "accentColorRGB")
            for accentColor in AccentColors.allCases {
                if let accentColorRGB = accentColor.rawValue.rgb() {
                    if fetchedAccentColorRGB == accentColorRGB {
                        self.accentColor = accentColor
                        break
                    }
                }
            }
        }
    }
    
    func saveCustomColor(color: AccentColors) {
        accentColor = color
        ownColorSet = false
        if let accentColorRGB = accentColor.rawValue.rgb() {
            UserDefaults.standard.set(accentColorRGB, forKey: "accentColorRGB")
            UserDefaults.standard.removeObject(forKey: "ownColorSet")
        }
    }
    
    func saveOwnColor() {
        ownColorSet = true
        if let ownColorRGB = UIColor(ownColor).rgb() {
            UserDefaults.standard.set(ownColorRGB, forKey: "ownColorRGB")
            UserDefaults.standard.set(ownColorSet, forKey: "ownColorSet")
        }
    }
}
