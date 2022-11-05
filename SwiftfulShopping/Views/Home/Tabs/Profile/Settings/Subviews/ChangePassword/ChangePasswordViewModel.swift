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
    
    @Published var showLoadingModal: Bool = false
    @Published var successfullyChanged: Bool = false
    
    var inputsInvalid: Bool {
        email.isEmpty ||
        oldPassword.isEmpty ||
        newPassword.isEmpty
    }
    
    func changePassword(completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        FirebaseAuthManager.client.changePassword(emailAddress: email,
                                                  oldPassword: oldPassword,
                                                  newPassword: newPassword) { [weak self] result in
            switch result {
            case .success:
                self?.successfullyChanged = true
            case .failure(_):
                break
            }
            
            self?.showLoadingModal = false
            completion(result)
        }
    }
}
