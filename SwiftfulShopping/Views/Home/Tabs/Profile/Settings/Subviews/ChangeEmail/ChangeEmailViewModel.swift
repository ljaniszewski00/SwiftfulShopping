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
    
    @Published var showLoadingModal: Bool = false
    @Published var successfullyChanged: Bool = false
    
    var inputsInvalid: Bool {
        oldEmail.isEmpty ||
        password.isEmpty ||
        newEmail.isEmpty
    }
    
    func changeEmail(completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        if let userID = FirebaseAuthManager.client.user?.uid {
            FirebaseAuthManager.client.changeEmailAddress(userID: userID,
                                                          oldEmailAddress: oldEmail,
                                                          password: password,
                                                          newEmailAddress: newEmail) { [weak self] result in
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
}
