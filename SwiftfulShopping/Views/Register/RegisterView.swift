//
//  RegisterView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import CoreLocationUI

struct RegisterView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
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
                            Button("Next") {
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
        .navigationTitle("Create Account")
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
                    Text("Personal Information:")
                        .font(.ssTitle1)
                        .foregroundColor(.accentColor)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 10) {
                            CustomTextField(textFieldProperty: "Full Name",
                                            textFieldImageName: "person",
                                            textFieldSignsLimit: 0,
                                            text: $registerViewModel.fullName,
                                            isFocusedParentView: $isFullNameTextFieldFocused)
                            
                            if !registerViewModel.isFullNameValid {
                                buildErrorMessage(message: "Full name should not contain any numbers and has to consist of at least two words.")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            CustomTextField(textFieldProperty: "Username",
                                            textFieldImageName: "person",
                                            textFieldSignsLimit: 20,
                                            text: $registerViewModel.username,
                                            isFocusedParentView: $isUsernameTextFieldFocused)
                            
                            if !registerViewModel.isUsernameValid {
                                buildErrorMessage(message: "Username should contain at least 5 characters")
                            }
                            
                            if registerViewModel.usernameTaken {
                                buildErrorMessage(message: "Username has already been taken")
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Birth Date:")
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                    CustomDatePicker(includeDayPicking: true, datePicked: $registerViewModel.birthDate)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Credentials:")
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(textFieldProperty: "E-mail",
                                        textFieldImageName: "envelope",
                                        textFieldSignsLimit: 0,
                                        text: $registerViewModel.email,
                                        isFocusedParentView: $isEmailTextFieldFocused)
                        
                        if !registerViewModel.isEmailValid {
                            buildErrorMessage(message: "Email should be between 2 and 64 characters and contain @")
                        }
                        
                        if registerViewModel.emailTaken {
                            buildErrorMessage(message: "Email has already been used")
                        }
                    }
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        CustomTextField(isSecureField: true,
                                        textFieldProperty: "Password",
                                        textFieldImageName: "lock",
                                        text: $registerViewModel.password,
                                        isFocusedParentView: $isPasswordTextFieldFocused)
                        
                        HStack(alignment: .top) {
                            if showPasswordHint {
                                Text("Password should be at least 8 characters long, should contain a number and a big letter")
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
        let contentViewModel: ContentViewModel = ContentViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                RegisterView()
                    .environmentObject(locationManager)
                    .environmentObject(contentViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
