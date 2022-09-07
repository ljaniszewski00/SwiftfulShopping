//
//  TabBarStateManager.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 04/04/2022.
//

import SwiftUI

class TabBarStateManager: ObservableObject {
    @Published var isHidden = false
    @Published var tabBarSize: CGSize = .zero
    
    func hideTabBar() {
        isHidden = true
        tabBarSize = .zero
    }
    
    func showTabBar() {
        isHidden = false
    }
}
