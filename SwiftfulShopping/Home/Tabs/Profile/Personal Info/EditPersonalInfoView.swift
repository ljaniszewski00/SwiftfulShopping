//
//  EditPersonalInfoView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import SwiftUI

struct EditPersonalInfoView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var personalInfoViewModel: PersonalInfoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isFirstNameTextFieldFocused: Bool = false
    @State private var isLastNameTextFieldFocused: Bool = false
    @State private var isEmailAddressTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    RectangleCustomTextField(
                        textFieldProperty: "First Name",
                        text: $personalInfoViewModel.newFirstName,
                        isFocusedParentView: $isFirstNameTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Last Name",
                        text: $personalInfoViewModel.newLastName,
                        isFocusedParentView: $isLastNameTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Email Address",
                        text: $personalInfoViewModel.newEmailAddress,
                        isFocusedParentView: $isEmailAddressTextFieldFocused)
                }
                
                Button {
                    withAnimation {
                        profileViewModel.addNewAddress(address: personalInfoViewModel.createNewAddress(), toBeDefault: personalInfoViewModel.toBeDefaultAddress)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Edit personal data")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(personalInfoViewModel.newPersonalInfoFieldsNotValidated)
            }
            .padding()
        }
        .navigationTitle("Edit personal data")
    }
}

struct EditPersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let personalInfoViewModel = PersonalInfoViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                EditPersonalInfoView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(personalInfoViewModel)
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
