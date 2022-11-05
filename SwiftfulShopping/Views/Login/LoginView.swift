//
//  LoginView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import texterify_ios_sdk

struct LoginView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModel()
    
    @StateObject var errorManager = ErrorManager.shared

    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var isPhoneNumberTextFieldFocused: Bool = false
    @State private var isVerificationCodeTextFieldFocused: Bool = false
    
    @State private var showForgotPasswordSheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        if colorScheme == .light {
                            Image(AssetsNames.logoHorizontalGray)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                        } else if colorScheme == .dark {
                            Image(AssetsNames.logoHorizontalWhite)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 40) {
                            VStack(spacing: 15) {
                                VStack(spacing: 20) {
                                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .loginView(.emailTextField)),
                                                    textFieldImageName: "envelope",
                                                    textFieldSignsLimit: 0,
                                                    text: $loginViewModel.email,
                                                    isFocusedParentView: $isEmailTextFieldFocused)
                                    
                                    CustomTextField(isSecureField: true,
                                                    textFieldProperty: TexterifyManager.localisedString(key: .loginView(.passwordTextField)),
                                                    textFieldImageName: "lock",
                                                    text: $loginViewModel.password,
                                                    isFocusedParentView: $isPasswordTextFieldFocused)
                                    
                                    HStack {
                                        Spacer()
                                        Text(TexterifyManager.localisedString(key: .loginView(.forgotPassword)))
                                            .font(.ssBody).fontWeight(.semibold)
                                            .foregroundColor(.accentColor)
                                            .onTapGesture {
                                                showForgotPasswordSheet = true
                                            }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 20) {
                                Button(TexterifyManager.localisedString(key: .loginView(.loginButton))) {
                                    withAnimation {
                                        loginViewModel.showLoadingModal = true
                                        loginViewModel.choosenSignInMethod = .emailPassword
                                        
                                        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: loginViewModel.email,
                                                                                               password: loginViewModel.password) { result in
                                            loginViewModel.showLoadingModal = false
                                            switch result {
                                            case .success:
                                                break
                                            case .failure(let error):
                                                ErrorManager.shared.generateCustomError(errorType: .emailPasswordSignInError,
                                                                                        additionalErrorDescription: error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(CustomButton())
                                .disabled(loginViewModel.email.isEmpty ? true : (loginViewModel.password.isEmpty ? true : false))
                                .contentShape(Rectangle())
                                
                                HStack(spacing: 10) {
                                    Text(TexterifyManager.localisedString(key: .loginView(.dontHaveAnAccount)))
                                        .font(.ssBody)
                                    
                                    NavigationLink(isActive: $contentViewModel.presentRegisterView) {
                                        RegisterView()
                                    } label: {
                                        Text(TexterifyManager.localisedString(key: .loginView(.registerHere)))
                                            .font(.ssBody).fontWeight(.semibold)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                
                                LabelledDivider(label: TexterifyManager.localisedString(key: .loginView(.orLabel)),
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
                        
                        NavigationLink(isActive: $loginViewModel.showFirstTimeLoginView) {
                            FirstTimeLoginView()
                        } label: {
                            EmptyView()
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
            .navigationTitle(TexterifyManager.localisedString(key: .loginView(.navigationTitle)))
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(.stack)
        .environmentObject(locationManager)
        .environmentObject(contentViewModel)
        .environmentObject(loginViewModel)
        .environmentObject(forgotPasswordViewModel)
    }
    
    
    // MARK: Phone Auth to be implemented after getting Apple Developer Account with APNs and Background Refresh
    
//    @ViewBuilder
//    func buildPhoneLogInButton() -> some View {
//        Button {
//            loginViewModel.choosenSignInMethod = .phoneNumber
//        } label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke()
//                    .foregroundColor(.ssDarkGray)
//                HStack {
//                    Image(systemName: "phone.fill")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                    Spacer()
//                    Text("Sign in with Phone Number")
//                        .font(.ssButton)
//                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
//                    Spacer()
//                }
//                .padding()
//            }
//        }
//    }
    
    @ViewBuilder
    func buildGoogleLogInButton() -> some View {
        Button {
            loginViewModel.choosenSignInMethod = .google
            FirebaseAuthManager.client.firebaseGoogleSignIn { result in
                switch result {
                case .success:
                    checkIfUserLoggingFirstTime()
                case .failure(let error):
                    ErrorManager.shared.generateCustomError(errorType: .googleSignInError,
                                                            additionalErrorDescription: error.localizedDescription)
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke()
                    .foregroundColor(.ssDarkGray)
                HStack {
                    Image(uiImage: UIImage(named: AssetsNames.googleLogo)!)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    Spacer()
                    Text(TexterifyManager.localisedString(key: .loginView(.signInWithGoogle)))
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
            loginViewModel.choosenSignInMethod = .facebook
            FirebaseAuthManager.client.firebaseFacebookSignIn { result in
                switch result {
                case .success:
                    checkIfUserLoggingFirstTime()
                case .failure(let error):
                    ErrorManager.shared.generateCustomError(errorType: .facebookSignInError,
                                                            additionalErrorDescription: error.localizedDescription)
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.facebookLoginButtonBackground)
                HStack {
                    Image(uiImage: UIImage(named: AssetsNames.facebookLogo)!)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Spacer()
                    Text(TexterifyManager.localisedString(key: .loginView(.signInWithFacebook)))
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
            loginViewModel.choosenSignInMethod = .github
            FirebaseAuthManager.client.firebaseGitHubSignIn { result in
                switch result {
                case .success:
                    checkIfUserLoggingFirstTime()
                case .failure(let error):
                    ErrorManager.shared.generateCustomError(errorType: .githubSignInError,
                                                            additionalErrorDescription: error.localizedDescription)
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.black)
                HStack {
                    Image(uiImage: UIImage(named: AssetsNames.githubLogo)!)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Spacer()
                    Text(TexterifyManager.localisedString(key: .loginView(.signInWithGitHub)))
                        .font(.ssButton)
                        .foregroundColor(.ssWhite)
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    func checkIfUserLoggingFirstTime() {
        // Checking if user is logging for the first time
        loginViewModel.checkIfUserLoggingFirstTime { result in
            switch result {
            case .success(let loggingFirstTime):
                if loggingFirstTime {
                    loginViewModel.showFirstTimeLoginView = true
                } else {
                    break
                }
            case .failure(let error):
                ErrorManager.shared.generateCustomError(errorType: .googleSignInError,
                                                        additionalErrorDescription: error.localizedDescription)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                LoginView()
                    .environmentObject(locationManager)
                    .environmentObject(contentViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
