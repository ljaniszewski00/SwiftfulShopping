//
//  DeleteAccountViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/08/2022.
//

import Foundation

class DeleteAccountViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var shouldPresentActionSheet: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    func deleteAccount(completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        FirebaseAuthManager.client.deleteUser(email: email,
                                              password: password) { [weak self] result in
            self?.showLoadingModal = false
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
