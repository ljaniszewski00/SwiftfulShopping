//
//  ChangePasswordView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ChangePasswordView: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var changePasswordViewModel: ChangePasswordViewModel = ChangePasswordViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isOldPasswordTextFieldFocused: Bool = false
    @State private var isNewPasswordTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(alignment: .trailing, spacing: 20) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .changePasswordView(.emailTextField)),
                                    textFieldImageName: "envelope.fill",
                                    textFieldKeyboardType: .emailAddress,
                                    text: $changePasswordViewModel.email,
                                    isFocusedParentView: $isEmailTextFieldFocused)
                    
                    CustomTextField(isSecureField: true,
                                    textFieldProperty: TexterifyManager.localisedString(key: .changePasswordView(.oldPasswordTextField)),
                                    textFieldImageName: "key.fill",
                                    text: $changePasswordViewModel.oldPassword,
                                    isFocusedParentView: $isOldPasswordTextFieldFocused)
                    
                    CustomTextField(isSecureField: true,
                                    textFieldProperty: TexterifyManager.localisedString(key: .changePasswordView(.newPasswordTextField)),
                                    textFieldImageName: "key.fill",
                                    text: $changePasswordViewModel.newPassword,
                                    isFocusedParentView: $isNewPasswordTextFieldFocused)
                    .padding(.bottom)
                    
                    Button {
                        withAnimation {
                            changePasswordViewModel.changePassword { result in
                                switch result {
                                case .success:
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        dismiss()
                                    }
                                case .failure(let error):
                                    errorManager.generateCustomError(errorType: .changePasswordError,
                                                                     additionalErrorDescription: error.localizedDescription)
                                }
                            }
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .changePasswordView(.changePasswordButton)))
                            .font(.ssButton)
                    }
                    .buttonStyle(RoundedCompletionButtonStyle(actionCompleted: changePasswordViewModel.successfullyChanged,
                                                              actionCompletedText: TexterifyManager.localisedString(key: .changePasswordView(.changePasswordButtonSuccessText))))
                    .disabled(changePasswordViewModel.inputsInvalid)
                }
                
                Spacer()
            }
            .padding()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                                            $changePasswordViewModel.showLoadingModal))
        .navigationTitle(TexterifyManager.localisedString(key: .changePasswordView(.navigationTitle)))
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

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ChangePasswordView()
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
