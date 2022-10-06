//
//  LoginViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var showLoadingModal: Bool = false
    
    @Published var choosenSignInMethod: SignInMethod = .emailPassword
    
    @Published var showFirstTimeLoginView: Bool = false
    
    func checkIfUserLoggingFirstTime(completion: @escaping ((Bool, Error?) -> ())) {
        FirestoreManager.client.getUsersUIDs() { usersUIDs in
            if let usersUIDs = usersUIDs, let user = FirebaseAuthManager.client.user {
                if usersUIDs.contains(user.uid) {
                    completion(false, nil)
                } else {
                    completion(true, nil)
                }
            } else {
                completion(true, nil)
            }
        }
    }
}
