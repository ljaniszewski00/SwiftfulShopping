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
    
    
    func addressProvidingCompletion(completion: @escaping ((Bool) -> ())) {
        
    }
    
    func verifyAccount() {
        
    }
}
