//
//  ForgotPasswordView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ForgotPasswordView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var forgotPasswordViewModel: ForgotPasswordViewModel
    
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isEmailTextFieldFocused: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(TexterifyManager.localisedString(key: .forgotPasswordView(.navigationTitle)))
                    .font(.ssTitle1)
                Text(TexterifyManager.localisedString(key: .forgotPasswordView(.instructionToTypeEmail)))
                    .font(.ssCallout)
                    .foregroundColor(.ssDarkGray)
            }
            .padding(.bottom)
            
            CustomTextField(textFieldProperty: "e-mail",
                            textFieldImageName: "envelope",
                            textFieldSignsLimit: 0,
                            text: $forgotPasswordViewModel.email,
                            isFocusedParentView: $isEmailTextFieldFocused)
            
            Spacer()
            
            Button(TexterifyManager.localisedString(key: .forgotPasswordView(.sendRecoveryEmail))) {
                forgotPasswordViewModel.showLoadingModal = true
                FirebaseAuthManager.client.firebaseSendPasswordReset(email: forgotPasswordViewModel.email) { result in
                    forgotPasswordViewModel.showLoadingModal = false
                    switch result {
                    case .success:
                        dismiss()
                    case .failure(let error):
                        ErrorManager.shared.generateCustomError(errorType: .changePasswordError,
                                                                additionalErrorDescription: error.localizedDescription)
                    }
                }
            }
            .buttonStyle(CustomButton())
            .contentShape(Rectangle())
            .padding(.bottom, 10)
            
            Button(TexterifyManager.localisedString(key: .common(.cancel))) {
                dismiss()
            }
            .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
            .contentShape(Rectangle())
            .padding(.bottom)
        }
        .padding()
        .background {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $forgotPasswordViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                             customError: errorManager.customError ?? ErrorManager.unknownError))
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let loginViewModel: LoginViewModel = LoginViewModel()
        let forgotPasswordViewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ForgotPasswordView()
                    .environmentObject(loginViewModel)
                    .environmentObject(forgotPasswordViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
