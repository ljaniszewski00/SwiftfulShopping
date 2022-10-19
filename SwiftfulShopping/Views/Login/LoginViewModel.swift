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
    
    func checkIfUserLoggingFirstTime(completion: @escaping ((Result<Bool, Error>) -> ())) {
        FirestoreAuthenticationManager.client.getUsersUIDs() { result in
            switch result {
            case .success(let usersUIDs):
                if let usersUIDs = usersUIDs, let user = FirebaseAuthManager.client.user {
                    if usersUIDs.contains(user.uid) {
                        completion(.success(false))
                    } else {
                        completion(.success(true))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
