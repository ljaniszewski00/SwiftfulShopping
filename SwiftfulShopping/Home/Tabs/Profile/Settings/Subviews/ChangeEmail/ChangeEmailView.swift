//
//  ChangeEmailView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct ChangeEmailView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
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
                    CustomTextField(textFieldProperty: "Old Email Address",
                                    textFieldImageName: "envelope.fill",
                                    textFieldKeyboardType: .emailAddress,
                                    text: $changeEmailViewModel.oldEmail,
                                    isFocusedParentView: $isOldEmailTextFieldFocused)
                    .disabled(changeEmailViewModel.showNewEmailTextField)
                    
                    CustomTextField(isSecureField: true,
                                    textFieldProperty: "Password",
                                    textFieldImageName: "key.fill",
                                    text: $changeEmailViewModel.password,
                                    isFocusedParentView: $isPasswordTextFieldFocused)
                    .disabled(changeEmailViewModel.showNewEmailTextField)
                    
                    Button {
                        withAnimation {
                            changeEmailViewModel.verifyCredentials()
                        }
                    } label: {
                        Text("Verify Credentials")
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                    .padding(.bottom, 30)
                    .disabled(changeEmailViewModel.showNewEmailTextField)
                }
                
                if changeEmailViewModel.showNewEmailTextField {
                    VStack(spacing: 0) {
                        CustomTextField(textFieldProperty: "New Email Address",
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
                            Text("Change Email Address")
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
        .navigationTitle("Change Email")
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
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SettingsView()
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
