//
//  DeleteAccountView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct DeleteAccountView: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var deleteAccountViewModel: DeleteAccountViewModel = DeleteAccountViewModel()
    @StateObject var errorManager = ErrorManager.shared
    @StateObject private var firebaseAuthManager = FirebaseAuthManager.client
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .deleteAccountView(.emailTextField)),
                                    textFieldImageName: "envelope.fill",
                                    textFieldKeyboardType: .emailAddress,
                                    text: $deleteAccountViewModel.email,
                                    isFocusedParentView: $isEmailTextFieldFocused)
                    
                    CustomTextField(isSecureField: true,
                                    textFieldProperty: TexterifyManager.localisedString(key: .deleteAccountView(.passwordTextField)),
                                    textFieldImageName: "key.fill",
                                    text: $deleteAccountViewModel.password,
                                    isFocusedParentView: $isPasswordTextFieldFocused)
                    
                    Button {
                        withAnimation {
                            deleteAccountViewModel.shouldPresentActionSheet = true
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .deleteAccountView(.deleteAccountButton)))
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
        .navigationTitle(TexterifyManager.localisedString(key: .deleteAccountView(.navigationTitle)))
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
            ActionSheet(title: Text(TexterifyManager.localisedString(key: .deleteAccountView(.confirmationSheetTitle))),
                        message: Text(TexterifyManager.localisedString(key: .deleteAccountView(.confirmationSheetMessage))), buttons: [
                .destructive(Text(TexterifyManager.localisedString(key: .deleteAccountView(.confirmationSheetConfirmButton))), action: {
                    deleteAccountViewModel.showLoadingModal = true
                    deleteAccountViewModel.deleteAccount { result in
                        deleteAccountViewModel.showLoadingModal = false
                        switch result {
                        case .success:
                            dismiss()
                        case .failure(let error):
                            errorManager.generateCustomError(errorType: .deleteAccountError,
                                                             additionalErrorDescription: error.localizedDescription)
                        }
                    }
                }),
                .cancel()
            ])
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsViewModel = SettingsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                DeleteAccountView()
                    .environmentObject(settingsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
