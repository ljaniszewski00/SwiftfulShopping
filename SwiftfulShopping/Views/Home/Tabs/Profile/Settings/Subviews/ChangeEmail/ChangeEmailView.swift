//
//  ChangeEmailView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ChangeEmailView: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var changeEmailViewModel: ChangeEmailViewModel = ChangeEmailViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isOldEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    @State private var isNewEmailTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .changeEmailView(.oldEmailTextField)),
                                    textFieldImageName: "envelope.fill",
                                    textFieldKeyboardType: .emailAddress,
                                    text: $changeEmailViewModel.oldEmail,
                                    isFocusedParentView: $isOldEmailTextFieldFocused)
                    .disabled(changeEmailViewModel.showNewEmailTextField)
                    
                    CustomTextField(isSecureField: true,
                                    textFieldProperty: TexterifyManager.localisedString(key: .changeEmailView(.passwordTextField)),
                                    textFieldImageName: "key.fill",
                                    text: $changeEmailViewModel.password,
                                    isFocusedParentView: $isPasswordTextFieldFocused)
                    .disabled(changeEmailViewModel.showNewEmailTextField)
                    
                    Button {
                        withAnimation {
                            changeEmailViewModel.verifyCredentials()
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .changeEmailView(.verifyButton)))
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                    .padding(.bottom, 30)
                    .disabled(changeEmailViewModel.showNewEmailTextField)
                }
                
                if changeEmailViewModel.showNewEmailTextField {
                    VStack(spacing: 0) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .changeEmailView(.newEmailTextField)),
                                        textFieldImageName: "envelope.fill",
                                        textFieldKeyboardType: .emailAddress,
                                        text: $changeEmailViewModel.newEmail,
                                        isFocusedParentView: $isNewEmailTextFieldFocused)
                        .padding(.bottom)
                        
                        Button {
                            withAnimation {
                                changeEmailViewModel.changeEmail()
                            }
                        } label: {
                            Text(TexterifyManager.localisedString(key: .changeEmailView(.changeEmailButton)))
                                .font(.ssButton)
                        }
                        .buttonStyle(CustomButton())
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                                            $changeEmailViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        .navigationTitle(TexterifyManager.localisedString(key: .changeEmailView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.large)
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

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SettingsView()
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
