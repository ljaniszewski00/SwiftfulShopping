//
//  RegisterView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import CoreLocationUI

struct RegisterView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var registerViewModel = RegisterViewModel()
    
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isFirstNameTextFieldFocused: Bool = false
    @State private var isLastNameTextFieldFocused: Bool = false
    @State private var isUsernameTextFieldFocused: Bool = false
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var showPasswordHint: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    StepsView(stepsNumber: 2, activeStep: 1)
                        .padding(.vertical)
                    
                    VStack {
                        buildRegisterFirstPane()
                            .padding(.bottom)
                        
                        Spacer()
                        
                        NavigationLink(isActive: $registerViewModel.presentSecondRegisterView) {
                            SecondRegisterView()
                                .environmentObject(authStateManager)
                                .environmentObject(locationManager)
                                .environmentObject(contentViewModel)
                                .environmentObject(registerViewModel)
                        } label: {
                            Button("Next") {
                                withAnimation {
                                    let (success, message) = registerViewModel.completeFirstRegistrationStep()
                                    if success {
                                        registerViewModel.dataError = false
                                        registerViewModel.presentSecondRegisterView = true
                                    } else {
                                        errorManager.generateCustomError(errorType: .registerError,
                                                                         additionalErrorDescription: message)
                                    }
                                }
                            }
                            .disabled(registerViewModel.checkPersonalDataFieldsEmpty())
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    registerViewModel.fillPersonalData()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.accentColor)
                })
            }
        }
    }
    
    @ViewBuilder
    func buildRegisterFirstPane() -> some View {
        VStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Personal Information:")
                        .font(.ssTitle1)
                        .foregroundColor(.accentColor)
                        .padding(.bottom)
                    
                    CustomTextField(textFieldProperty: "First Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.firstName, isFocusedParentView: $isFirstNameTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Last Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.lastName, isFocusedParentView: $isLastNameTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Username", textFieldImageName: "person", textFieldSignsLimit: 20, text: $registerViewModel.username, isFocusedParentView: $isUsernameTextFieldFocused)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Birth Date:")
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                    CustomDatePicker(includeDayPicking: true, datePicked: $registerViewModel.birthDate)
                }
            }
            .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Credentials:")
                    .font(.ssTitle2)
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
                
                CustomTextField(textFieldProperty: "E-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $registerViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
                
                VStack(alignment: .trailing, spacing: 10) {
                    CustomTextField(isSecureField: true, textFieldProperty: "Password", textFieldImageName: "lock", text: $registerViewModel.password, isFocusedParentView: $isPasswordTextFieldFocused)
                    
                    HStack(alignment: .center) {
                        if showPasswordHint {
                            Text("Password should be at least 8 characters long and should contain a number.")
                                .font(.ssCallout)
                                .foregroundColor(registerViewModel.dataError ? .red : .ssGray)
                        }
                        
                        Spacer()
                        
                        Button {
                            showPasswordHint.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(registerViewModel.dataError ? .red : showPasswordHint ? .accentColor : .ssGray)
                        }
                    }
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager: AuthStateManager = AuthStateManager()
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                RegisterView()
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
