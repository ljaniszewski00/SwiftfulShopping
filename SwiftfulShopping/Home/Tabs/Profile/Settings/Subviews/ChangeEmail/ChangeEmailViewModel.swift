//
//  ChangeEmailViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/08/2022.
//

import Foundation

class ChangeEmailViewModel: ObservableObject {
    @Published var oldEmail: String = ""
    @Published var password: String = ""
    @Published var newEmail: String = ""
    
    @Published var showNewEmailTextField: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    func verifyCredentials() {
        showNewEmailTextField = true
    }
    
    func changeEmail() {
        
    }
}
