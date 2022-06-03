//
//  TabBarStateManager.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 04/04/2022.
//

import Foundation

class TabBarStateManager: ObservableObject {
    @Published var isHidden = false
    
    func hideTabBar() {
        isHidden = true
    }
    
    func showTabBar() {
        isHidden = false
    }
}
