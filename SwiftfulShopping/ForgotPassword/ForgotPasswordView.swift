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
        self.forgotPasswordViewModel.email = email
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
                .padding(.bottom, 20)
            
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
            .buttonStyle(CustomButton(buttonColor: .red))
            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9)
            .contentShape(Rectangle())
        }
        .padding()
        .position(x: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5, y: ScreenBoundsSupplier.shared.getScreenHeight() * 0.3)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
