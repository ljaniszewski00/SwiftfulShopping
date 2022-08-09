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
    
    private func verifyCredentials() {
        
    }
    
    func deleteAccount() {
        
    }
}
