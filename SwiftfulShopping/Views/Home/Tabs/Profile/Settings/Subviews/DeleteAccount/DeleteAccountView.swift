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
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var deleteAccountViewModel: DeleteAccountViewModel = DeleteAccountViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
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
                    
                    Button {
                        withAnimation {
                            deleteAccountViewModel.shouldPresentActionSheet = true
                        }
                    } label: {
                        Text("Delete Account")
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                    .padding(.bottom, 30)
                }
            }
            .padding()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                                            $deleteAccountViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
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
        let authStateManager = AuthStateManager()
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
                        authStateManager.didLogged()
                    }
            }
        }
    }
}
