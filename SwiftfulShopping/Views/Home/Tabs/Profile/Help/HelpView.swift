//
//  HelpView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var helpViewModel: HelpViewModel = HelpViewModel()
    
    @State private var isContactEmailTextFieldFocused: Bool = false
    @State private var isContactPhoneNumberTextFieldFocused: Bool = false
    @State private var isNewsletterEmailTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 80) {
                VStack(alignment: .leading, spacing: 30) {
                    Text("Contact Us")
                        .font(.ssTitle2)
                    VStack(alignment: .trailing, spacing: 20) {
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
                                .font(.ssButton)
                        }
                        .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: helpViewModel.contactUsButtonClicked, actionCompletedText: "Wait until We contact You"))
                        .contentShape(Rectangle())
                        .disabled(helpViewModel.contactUsInfoNotValidated)
                    }
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("Subscribe to Newsletter")
                        .font(.ssTitle2)
                    VStack(alignment: .trailing, spacing: 20) {
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
                                .font(.ssButton)
                        }
                        .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: helpViewModel.signForNewsletterActionClicked, actionCompletedText: "Subscribed"))
                        .contentShape(Rectangle())
                        .disabled(helpViewModel.newsletterEmailNotValidated)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                HelpView()
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
