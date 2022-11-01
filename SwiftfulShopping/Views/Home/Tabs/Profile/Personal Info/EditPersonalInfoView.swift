//
//  EditPersonalInfoView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct EditPersonalInfoView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var personalInfoViewModel: PersonalInfoViewModel
    @Environment(\.dismiss) var dismiss
    
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isFullNameTextFieldFocused: Bool = false
    @State private var isEmailAddressTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .editPersonalInfoView(.fullNameTextField)),
                        text: $personalInfoViewModel.newFullName,
                        isFocusedParentView: $isFullNameTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .editPersonalInfoView(.emailAddressTextField)),
                        text: $personalInfoViewModel.newEmailAddress,
                        isFocusedParentView: $isEmailAddressTextFieldFocused)
                }
                
                Button {
                    withAnimation {
                        if let newAddress = personalInfoViewModel.createNewAddress() {
                            personalInfoViewModel.showLoadingModal = true
                            profileViewModel.addNewAddress(address: newAddress, toBeDefault: personalInfoViewModel.toBeDefaultAddress) { result in
                                personalInfoViewModel.showLoadingModal = false
                                switch result {
                                case .success:
                                    dismiss()
                                case .failure(let error):
                                    errorManager.generateCustomError(errorType: .createAddressError,
                                                                     additionalErrorDescription: error.localizedDescription)
                                }
                            }
                        }
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .editPersonalInfoView(.saveButton)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(personalInfoViewModel.newPersonalInfoFieldsNotValidated)
            }
            .padding()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $personalInfoViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                             customError: errorManager.customError ?? ErrorManager.unknownError))
        .navigationTitle(TexterifyManager.localisedString(key: .editPersonalInfoView(.navigationTitle)))
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
    }
}

struct EditPersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let personalInfoViewModel = PersonalInfoViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                EditPersonalInfoView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(personalInfoViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
