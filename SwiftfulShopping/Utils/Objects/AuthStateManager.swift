//
//  AuthStateManager.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 03/04/2022.
//

import Foundation

class AuthStateManager: ObservableObject {
    @Published var isLogged: Bool = false
    
    func didLogged() {
        self.isLogged = true
    }
    
    func didLogout() {
        self.isLogged = false
    }
}
