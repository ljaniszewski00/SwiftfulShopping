//
//  LoginView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject private var authStateManager: AuthStateManager

    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var showForgotPasswordSheet = false
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.accentColor)
                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 1.3)
                .position(x: ScreenBoundsSupplier.shared.getScreenWidth() * 0.515, y: ScreenBoundsSupplier.shared.getScreenHeight() * 0.1)
            
            VStack {
                Spacer()
                
                Group {
                    Text("Sign in with your social media account:")
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    HStack {
                        Image(uiImage: UIImage(named: "google_logo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(.horizontal)
                        Image(uiImage: UIImage(named: "facebook_logo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(.horizontal)
                        Image(uiImage: UIImage(named: "github_logo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(.horizontal)
                    }
                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.07)
                    
                    LabelledDivider(label: "or", color: .black)
                        .padding(.vertical)
                }
                .isHidden(isEmailTextFieldFocused || isPasswordTextFieldFocused)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.95, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.45)
                        .foregroundColor(.white)
                    
                    VStack {
                        Text("Sign in with your credentials:")
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        CustomTextField(textFieldProperty: "e-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $loginViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
                        
                        CustomTextField(isSecureField: true, textFieldProperty: "password", textFieldImageName: "lock", text: $loginViewModel.password, isFocusedParentView: $isPasswordTextFieldFocused)
                        
                        Button("Login") {
                            withAnimation() {
                                authStateManager.didLogged()
                            }
                        }
                        .buttonStyle(CustomButton())
                        .disabled(loginViewModel.email.isEmpty ? true : (loginViewModel.password.isEmpty ? true : false))
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9)
                        .contentShape(Rectangle())
                        .padding(.bottom, 20)
                        
                        HStack {
                            Spacer()
                            Text("Forgot password?")
                                .foregroundColor(.accentColor)
                                .onTapGesture {
                                    showForgotPasswordSheet = true
                                }
                            Spacer()
                        }
                        .sheet(isPresented: $showForgotPasswordSheet) {
                            ForgotPasswordView(email: loginViewModel.email)
                        }
                    }
                }
                .offset(y: isEmailTextFieldFocused ? ScreenBoundsSupplier.shared.getScreenHeight() * -0.1 : (isPasswordTextFieldFocused ? ScreenBoundsSupplier.shared.getScreenHeight() * -0.1 : 0))
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Login")
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                })
            }
        }
        .background(Color.backgroundColor.ignoresSafeArea())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                LoginView()
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
