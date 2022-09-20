//
//  AuthStateManager.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 03/04/2022.
//

import Foundation

class AuthStateManager: ObservableObject {
    @Published var isLogged: Bool = false
    var loggedWith: SignInMethod?
    
    func didLogged(with signInMethod: SignInMethod) {
        self.loggedWith = signInMethod
        self.isLogged = true
    }
    
    func didLogout() {
        self.loggedWith = nil
        self.isLogged = false
    }
}
