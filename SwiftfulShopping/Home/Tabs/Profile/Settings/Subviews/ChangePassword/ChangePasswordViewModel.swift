//
//  ChangePasswordViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/08/2022.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    
    @Published var showNewPasswordTextField: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    func verifyCredentials() {
        showNewPasswordTextField = true
    }
    
    func changePassword() {
        
    }
}
