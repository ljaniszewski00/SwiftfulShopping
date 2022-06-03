//
//  ScreenBoundsSupplier.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

class ScreenBoundsSupplier: ObservableObject {
    
    static let shared = ScreenBoundsSupplier()
    
    private init() {}
    
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
