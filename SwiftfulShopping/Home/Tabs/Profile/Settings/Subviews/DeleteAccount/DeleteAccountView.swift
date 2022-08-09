//
//  DeleteAccountView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    @StateObject private var deleteAccountViewModel: DeleteAccountViewModel = DeleteAccountViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 0) {
                CustomTextField(textFieldProperty: "Old Email Address",
                                textFieldImageName: "envelope.fill",
                                textFieldKeyboardType: .emailAddress,
                                text: $deleteAccountViewModel.email,
                                isFocusedParentView: $isEmailTextFieldFocused)
                
                CustomTextField(isSecureField: true,
                                textFieldProperty: "Password",
                                textFieldImageName: "key.fill",
                                text: $deleteAccountViewModel.password,
                                isFocusedParentView: $isPasswordTextFieldFocused)
                
                Spacer()
                
                Button {
                    withAnimation {
                        deleteAccountViewModel.shouldPresentActionSheet = true
                    }
                } label: {
                    Text("Delete Account")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .padding(.bottom, 30)
            }
        }
        .padding()
        .scrollOnOverflow()
        .modifier(LoadingIndicatorModal(isPresented:
                                                            $deleteAccountViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.large)
        .actionSheet(isPresented: $deleteAccountViewModel.shouldPresentActionSheet) {
            ActionSheet(title: Text("Are you sure?"), message: Text("All your data will be lost!"), buttons: [
                .destructive(Text("Delete Account"), action: {
                    deleteAccountViewModel.deleteAccount()
                }),
                .cancel()
            ])
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                DeleteAccountView()
                    .environmentObject(authStateManager)
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
