//
//  HelpView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI
import texterify_ios_sdk

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
                    Text(TexterifyManager.localisedString(key: .helpView(.contactUs)))
                        .font(.ssTitle2)
                    VStack(alignment: .trailing, spacing: 20) {
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .helpView(.emailAddresTextField)),
                            text: $helpViewModel.contactUsEmail,
                            isFocusedParentView: $isContactEmailTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .helpView(.phoneNumberTextField)),
                            textFieldFooter: TexterifyManager.localisedString(key: .helpView(.phoneNumberTextFieldFooter)),
                            text: $helpViewModel.contactUsPhoneNumber,
                            isFocusedParentView: $isContactPhoneNumberTextFieldFocused)
                        .padding(.bottom)
                        
                        Button {
                            withAnimation {
                                helpViewModel.sendContactRequest()
                            }
                        } label: {
                            Text(TexterifyManager.localisedString(key: .helpView(.contactUsButton)))
                                .font(.ssButton)
                        }
                        .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: helpViewModel.contactUsButtonClicked, actionCompletedText: TexterifyManager.localisedString(key: .helpView(.waitInfo))))
                        .contentShape(Rectangle())
                        .disabled(helpViewModel.contactUsInfoNotValidated)
                    }
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    Text(TexterifyManager.localisedString(key: .helpView(.subscribeToNewsletter)))
                        .font(.ssTitle2)
                    VStack(alignment: .trailing, spacing: 20) {
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .helpView(.emailAddressNewsletterTextField)),
                            text: $helpViewModel.newsletterEmail,
                            isFocusedParentView: $isNewsletterEmailTextFieldFocused)
                        .padding(.bottom)
                        
                        Button {
                            withAnimation {
                                helpViewModel.signForNewsletter()
                            }
                        } label: {
                            Text(TexterifyManager.localisedString(key: .helpView(.subscribeToNewsletterButton)))
                                .font(.ssButton)
                        }
                        .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: helpViewModel.signForNewsletterActionClicked, actionCompletedText: TexterifyManager.localisedString(key: .helpView(.subscribedToNewsletterCompletedButton))))
                        .contentShape(Rectangle())
                        .disabled(helpViewModel.newsletterEmailNotValidated)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(TexterifyManager.localisedString(key: .helpView(.navigationTitle)))
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
