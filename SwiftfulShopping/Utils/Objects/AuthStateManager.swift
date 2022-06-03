//
//  AuthStateManager.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 03/04/2022.
//

import Foundation

class AuthStateManager: ObservableObject {
    @Published var isLogged: Bool = false
    @Published var isGuest: Bool = false
    
    init(isGuestDefault: Bool = false) {
        if isGuestDefault {
            isGuest = true
        } else {
            if let isGuest = UserDefaults.standard.value(forKey: "isGuest") as? Bool {
                self.isGuest = isGuest
            }
        }
    }
    
    func didLogged() {
        UserDefaults.standard.set(false, forKey: "isGuest")
        self.isLogged = true
        self.isGuest = false
    }
    
    func didEnterAsGuest() {
        UserDefaults.standard.set(true, forKey: "isGuest")
        self.isLogged = false
        self.isGuest = true
    }
    
    func logoutCompletely() {
        UserDefaults.standard.set(false, forKey: "isGuest")
        self.isLogged = false
        self.isGuest = false
    }
}
