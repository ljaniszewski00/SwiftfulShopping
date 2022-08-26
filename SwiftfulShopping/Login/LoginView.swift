//
//  LoginView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModel()

    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var showForgotPasswordSheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("AppIconImage")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .scaledToFit()
                            .padding(40)
                            .background {
                                Rectangle()
                                    .foregroundColor(.accentColor)
                            }
                            .padding(.bottom)
                        
                        VStack(spacing: 40) {
                            VStack(spacing: 15) {
                                VStack(spacing: 20) {
                                    CustomTextField(textFieldProperty: "e-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $loginViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
                                    
                                    CustomTextField(isSecureField: true, textFieldProperty: "password", textFieldImageName: "lock", text: $loginViewModel.password, isFocusedParentView: $isPasswordTextFieldFocused)
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("Forgot password?")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(.accentColor)
                                        .onTapGesture {
                                            showForgotPasswordSheet = true
                                        }
                                }
                            }
                            
                            VStack(spacing: 20) {
                                Button("Login") {
                                    withAnimation() {
                                        authStateManager.didLogged()
                                    }
                                }
                                .buttonStyle(CustomButton())
                                .disabled(loginViewModel.email.isEmpty ? true : (loginViewModel.password.isEmpty ? true : false))
                                .contentShape(Rectangle())
                                
                                HStack(spacing: 10) {
                                    Text("Don't have an account?")
                                        .font(.system(size: 16, weight: .regular, design: .rounded))
                                    
                                    NavigationLink(isActive: $contentViewModel.presentRegisterView) {
                                        RegisterView()
                                            .environmentObject(authStateManager)
                                            .environmentObject(locationManager)
                                            .environmentObject(contentViewModel)
                                    } label: {
                                        Text("Register here")
                                            .foregroundColor(.accentColor)
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    }
                                }
                                
                                LabelledDivider(label: "Or join using",
                                                color: colorScheme == .light ? .black : .white)
                                    .padding(.vertical)
                                
                                HStack(spacing: 40) {
                                    Button {
                                        
                                    } label: {
                                        Image(uiImage: UIImage(named: "google_logo")!)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                    }
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(uiImage: UIImage(named: "facebook_logo")!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                    }
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(uiImage: UIImage(named: "github_logo")!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                    }
                                }
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.6)
                            }
                        }
                        .padding()
                        .sheet(isPresented: $showForgotPasswordSheet) {
                            ForgotPasswordView()
                                .environmentObject(forgotPasswordViewModel)
                                .onAppear {
                                    forgotPasswordViewModel.email = loginViewModel.email
                                }
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .navigationTitle("Login")
            .navigationBarHidden(true)
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
            .background {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager: AuthStateManager = AuthStateManager()
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                LoginView()
                    .environmentObject(authStateManager)
                    .environmentObject(locationManager)
                    .environmentObject(contentViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
