//
//  RegisterView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import CoreLocationUI
import texterify_ios_sdk

struct RegisterView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var startViewModel: StartViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var registerViewModel = RegisterViewModel()
    
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isFullNameTextFieldFocused: Bool = false
    @State private var isUsernameTextFieldFocused: Bool = false
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var showPasswordHint: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    StepsView(stepsNumber: 2, activeStep: 1)
                        .padding(.bottom)
                    
                    VStack {
                        buildRegisterFirstPane()
                            .padding(.bottom)
                        
                        Spacer()
                        
                        NavigationLink(isActive: $registerViewModel.presentSecondRegisterView) {
                            SecondRegisterView()
                                .environmentObject(registerViewModel)
                        } label: {
                            Button(TexterifyManager.localisedString(key: .common(.next))) {
                                withAnimation {
                                    registerViewModel.completeFirstRegisterStep()
                                }
                            }
                            .disabled(!registerViewModel.canCompleteFirstRegistrationStep)
                            .buttonStyle(CustomButton())
                            .contentShape(Rectangle())
                        }
                    }
                }
                .padding()
                .frame(minWidth: geometry.size.width,
                       minHeight: geometry.size.height)
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                $registerViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
            .onAppear {
                registerViewModel.onFirstRegisterViewAppear()
            }
        }
        .background {
            Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
        }
        .navigationTitle(TexterifyManager.localisedString(key: .registerView(.navigationTitle)))
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.accentColor)
                })
            }
        }
    }
    
    @ViewBuilder
    func buildRegisterFirstPane() -> some View {
        VStack {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(TexterifyManager.localisedString(key: .registerView(.personalInformationLabel)))
                        .font(.ssTitle1)
                        .foregroundColor(.accentColor)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 10) {
                            CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .registerView(.fullNameTextField)),
                                            textFieldImageName: "person",
                                            textFieldSignsLimit: 0,
                                            text: $registerViewModel.fullName,
                                            isFocusedParentView: $isFullNameTextFieldFocused)
                            
                            if !registerViewModel.isFullNameValid {
                                buildErrorMessage(message: TexterifyManager.localisedString(key: .registerView(.fullNameError)))
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .registerView(.usernameTextField)),
                                            textFieldImageName: "person",
                                            textFieldSignsLimit: 20,
                                            text: $registerViewModel.username,
                                            isFocusedParentView: $isUsernameTextFieldFocused)
                            
                            if !registerViewModel.isUsernameValid {
                                buildErrorMessage(message: TexterifyManager.localisedString(key: .registerView(.usernameErrorCharacters)))
                            }
                            
                            if registerViewModel.usernameTaken {
                                buildErrorMessage(message: TexterifyManager.localisedString(key: .registerView(.usernameErrorTaken)))
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(TexterifyManager.localisedString(key: .registerView(.birthDataLabel)))
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                    CustomDatePicker(includeDayPicking: true, datePicked: $registerViewModel.birthDate)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(TexterifyManager.localisedString(key: .registerView(.credentialsLabel)))
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .registerView(.emailTextField)),
                                        textFieldImageName: "envelope",
                                        textFieldSignsLimit: 0,
                                        text: $registerViewModel.email,
                                        isFocusedParentView: $isEmailTextFieldFocused)
                        
                        if !registerViewModel.isEmailValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .registerView(.emailErrorCharacters)))
                        }
                        
                        if registerViewModel.emailTaken {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .registerView(.emailErrorTaken)))
                        }
                    }
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        CustomTextField(isSecureField: true,
                                        textFieldProperty: TexterifyManager.localisedString(key: .registerView(.passwordTextField)),
                                        textFieldImageName: "lock",
                                        text: $registerViewModel.password,
                                        isFocusedParentView: $isPasswordTextFieldFocused)
                        
                        HStack(alignment: .top) {
                            if showPasswordHint {
                                Text(TexterifyManager.localisedString(key: .registerView(.passwordError)))
                                    .font(.ssCaption1)
                                    .foregroundColor(registerViewModel.isPasswordValid ? .ssDarkGray : .red)
                            }
                            
                            Spacer()
                            
                            Button {
                                showPasswordHint.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(registerViewModel.isPasswordValid ? .ssDarkGray : .red)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func buildErrorMessage(message: String) -> some View {
        Text(message)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.red)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager: LocationManager = LocationManager()
        let startViewModel: StartViewModel = StartViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                RegisterView()
                    .environmentObject(locationManager)
                    .environmentObject(startViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
