//
//  ForgotPasswordView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var forgotPasswordViewModel: ForgotPasswordViewModel
    
    @State private var isEmailTextFieldFocused: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Forgot your password?")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                Text("Please, type your e-mail and we will send you a link so that you can reset the password.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
            }
            .padding(.bottom)
            
            CustomTextField(textFieldProperty: "e-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $forgotPasswordViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
            
            Spacer()
            
            Button("Reset password") {
                dismiss()
            }
            .buttonStyle(CustomButton())
            .contentShape(Rectangle())
            .padding(.bottom, 10)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
            .contentShape(Rectangle())
            .padding(.bottom)
        }
        .padding()
        .background {
            Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
        }
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
