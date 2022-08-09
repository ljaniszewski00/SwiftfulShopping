//
//  ChangePasswordView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    @StateObject private var changePasswordViewModel: ChangePasswordViewModel = ChangePasswordViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isOldPasswordTextFieldFocused: Bool = false
    @State private var isNewPasswordTextFieldFocused: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 0) {
                CustomTextField(textFieldProperty: "Email Address",
                                textFieldImageName: "envelope.fill",
                                textFieldKeyboardType: .emailAddress,
                                text: $changePasswordViewModel.email,
                                isFocusedParentView: $isEmailTextFieldFocused)
                .disabled(changePasswordViewModel.showNewPasswordTextField)
                
                CustomTextField(isSecureField: true,
                                textFieldProperty: "Old Password",
                                textFieldImageName: "key.fill",
                                text: $changePasswordViewModel.oldPassword,
                                isFocusedParentView: $isOldPasswordTextFieldFocused)
                .disabled(changePasswordViewModel.showNewPasswordTextField)
                .padding(.bottom)
                
                Button {
                    withAnimation {
                        changePasswordViewModel.verifyCredentials()
                    }
                } label: {
                    Text("Verify Credentials")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .padding(.bottom, 30)
                .disabled(changePasswordViewModel.showNewPasswordTextField)
            }
            
            if changePasswordViewModel.showNewPasswordTextField {
                VStack(spacing: 0) {
                    CustomTextField(isSecureField: true,
                                    textFieldProperty: "New Password",
                                    textFieldImageName: "key.fill",
                                    text: $changePasswordViewModel.newPassword,
                                    isFocusedParentView: $isNewPasswordTextFieldFocused)
                    .padding(.bottom)
                    
                    Button {
                        withAnimation {
                            changePasswordViewModel.changePassword()
                        }
                    } label: {
                        Text("Change Password")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton())
                }
            }
            
            Spacer()
        }
        .padding()
        .scrollOnOverflow()
        .modifier(LoadingIndicatorModal(isPresented:
                                                            $changePasswordViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ChangePasswordView()
                    .environmentObject(authStateManager)
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
