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
    var tabBarFirstAppearSet: Bool = false
    var tabBarActualSize: CGSize = .zero
    
    var screenBottomPaddingForViews: CGFloat {
        tabBarSize.height + 15
    }
    
    func hideTabBar() {
        isHidden = true
        tabBarSize = .zero
    }
    
    func showTabBar() {
        isHidden = false
    }
    
    func changeTabBarValuesFor(tabBarNewSize: CGSize) {
        if tabBarNewSize != .zero {
            if !tabBarFirstAppearSet {
                tabBarActualSize = tabBarNewSize
                tabBarFirstAppearSet = true
            } else {
                tabBarSize = tabBarActualSize
            }
        }
    }
}
