//
//  HelpView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct HelpView: View {
    @StateObject private var helpViewModel: HelpViewModel = HelpViewModel()
    
    @State private var isContactEmailTextFieldFocused: Bool = false
    @State private var isContactPhoneNumberTextFieldFocused: Bool = false
    @State private var isNewsletterEmailTextFieldFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 80) {
            VStack(alignment: .center, spacing: 30) {
                Text("Contact Us")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                VStack(alignment: .trailing) {
                    RectangleCustomTextField(
                        textFieldProperty: "Email Address",
                        text: $helpViewModel.contactUsEmail,
                        isFocusedParentView: $isContactEmailTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Phone Number",
                        textFieldFooter: "Please provide either your email address or phone number",
                        text: $helpViewModel.contactUsPhoneNumber,
                        isFocusedParentView: $isContactPhoneNumberTextFieldFocused)
                    .padding(.bottom)
                    
                    Button {
                        withAnimation {
                            helpViewModel.sendContactRequest()
                        }
                    } label: {
                        Text("Contact Us")
                    }
                    .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: helpViewModel.contactUsButtonClicked, actionCompletedText: "Wait until We contact You"))
                    .contentShape(Rectangle())
                    .disabled(helpViewModel.contactUsInfoNotValidated)
                }
            }
            
            VStack(alignment: .center, spacing: 30) {
                Text("Subscribe to Newsletter")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                VStack(alignment: .trailing) {
                    RectangleCustomTextField(
                        textFieldProperty: "Email Address",
                        text: $helpViewModel.newsletterEmail,
                        isFocusedParentView: $isNewsletterEmailTextFieldFocused)
                    .padding(.bottom)
                    
                    Button {
                        withAnimation {
                            helpViewModel.signForNewsletter()
                        }
                    } label: {
                        Text("Subscribe")
                    }
                    .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: helpViewModel.signForNewsletterActionClicked, actionCompletedText: "Subscribed"))
                    .contentShape(Rectangle())
                    .disabled(helpViewModel.newsletterEmailNotValidated)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Help")
        .scrollOnOverflow(showScrollIndicators: false)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
