//
//  HelpViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import Foundation

class HelpViewModel: ObservableObject {
    @Published var contactUsEmail: String = ""
    @Published var contactUsPhoneNumber: String = ""
    @Published var newsletterEmail: String = ""
    
    @Published var contactUsButtonClicked: Bool = false
    @Published var signForNewsletterActionClicked: Bool = false
    
    var contactUsInfoNotValidated: Bool {
        contactUsEmail.isEmpty && contactUsPhoneNumber.isEmpty
    }
    
    var newsletterEmailNotValidated: Bool {
        newsletterEmail.isEmpty
    }
    
    func sendContactRequest() {
        contactUsButtonClicked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
            contactUsButtonClicked = false
        }
    }
    
    func signForNewsletter() {
        signForNewsletterActionClicked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            signForNewsletterActionClicked = false
        }
    }
}
