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
    
    @StateObject var errorManager = ErrorManager.shared

    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var showForgotPasswordSheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        if colorScheme == .light {
                            Image("SwiftfulShoppingLogo - horizontal (gray)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                        } else if colorScheme == .dark {
                            Image("SwiftfulShoppingLogo - horizontal (white)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 40) {
                            VStack(spacing: 15) {
                                VStack(spacing: 20) {
                                    CustomTextField(textFieldProperty: "e-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $loginViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
                                    
                                    CustomTextField(isSecureField: true, textFieldProperty: "password", textFieldImageName: "lock", text: $loginViewModel.password, isFocusedParentView: $isPasswordTextFieldFocused)
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("Forgot password?")
                                        .font(.ssBody).fontWeight(.semibold)
                                        .foregroundColor(.accentColor)
                                        .onTapGesture {
                                            showForgotPasswordSheet = true
                                        }
                                }
                            }
                            
                            Spacer()
                            
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
                                        .font(.ssBody)
                                    
                                    NavigationLink(isActive: $contentViewModel.presentRegisterView) {
                                        RegisterView()
                                    } label: {
                                        Text("Register here")
                                            .font(.ssBody).fontWeight(.semibold)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                
                                LabelledDivider(label: "Or",
                                                color: colorScheme == .light ? .black : .ssWhite)
                                    .padding(.vertical)
                                
                                buildGoogleLogInButton()
                                buildFacebookLogInButton()
                                buildGitHubLogInButton()
                            }
                        }
                        .frame(maxHeight: .infinity)
                        .padding()
                        .sheet(isPresented: $showForgotPasswordSheet) {
                            ForgotPasswordView()
                                .onAppear {
                                    forgotPasswordViewModel.email = loginViewModel.email
                                }
                        }
                    }
                    .frame(minWidth: geometry.size.width,
                           minHeight: geometry.size.height)
                }
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .ignoresSafeArea()
                }
                .modifier(LoadingIndicatorModal(isPresented:
                                                    $loginViewModel.showLoadingModal))
                .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                     customError: errorManager.customError ?? ErrorManager.unknownError))
            }
            .navigationTitle("Login")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(.stack)
        .environmentObject(authStateManager)
        .environmentObject(locationManager)
        .environmentObject(contentViewModel)
        .environmentObject(loginViewModel)
        .environmentObject(forgotPasswordViewModel)
    }
    
    @ViewBuilder
    func buildGoogleLogInButton() -> some View {
        Button {
            FirebaseAuthManager.client.firebaseGoogleSignIn { success, error in
                if success {
                    authStateManager.didLogged()
                } else {
                    if let error = error {
                        ErrorManager.shared.generateCustomError(errorType: .googleSignInError,
                                                                additionalErrorDescription: error.localizedDescription)
                    }
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke()
                    .foregroundColor(.ssDarkGray)
                HStack {
                    Image(uiImage: UIImage(named: "google_logo")!)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    Spacer()
                    Text("Sign in with Google")
                        .font(.ssButton)
                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func buildFacebookLogInButton() -> some View {
        Button {
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(hex: "#1977F2"))
                HStack {
                    Image(uiImage: UIImage(named: "facebook_logo")!)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Spacer()
                    Text("Sign in with Facebook")
                        .font(.ssButton)
                        .foregroundColor(.ssWhite)
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func buildGitHubLogInButton() -> some View {
        Button {
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.black)
                HStack {
                    Image(uiImage: UIImage(named: "github_logo")!)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Spacer()
                    Text("Sign in with GitHub")
                        .font(.ssButton)
                        .foregroundColor(.ssWhite)
                    Spacer()
                }
                .padding()
            }
        }
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
