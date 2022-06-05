//
//  ForgotPasswordView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModel()
    @State private var isEmailTextFieldFocused: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    init(email: String = "") {
        forgotPasswordViewModel.email = email
    }
    
    var body: some View {
        VStack {
            Text("Forgot your password?")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 40)
            Text("Please, type your e-mail and we will send you a link so that you can reset the password.")
                .font(.callout)
                .padding(.bottom, 20)
            
            CustomTextField(textFieldProperty: "e-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $forgotPasswordViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
            
            Spacer()
            
            Button("Reset password") {
                dismiss()
            }
            .buttonStyle(CustomButton())
            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9)
            .contentShape(Rectangle())
            .padding(.bottom, 10)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9)
            .contentShape(Rectangle())
            .padding(.bottom)
        }
        .padding()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
