//
//  AddNewAddressView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import SwiftUI

struct AddNewAddressView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var personalInfoViewModel: PersonalInfoViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    RectangleCustomTextField(
                        textFieldProperty: "Street Name",
                        text: $personalInfoViewModel.newStreetName,
                        isFocusedParentView: $isStreetNameTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Street Number",
                        text: $personalInfoViewModel.newStreetNumber,
                        isFocusedParentView: $isStreetNumberTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Apartment Number",
                        textFieldFooter: "This field is optional",
                        text: $personalInfoViewModel.newApartmentNumber,
                        isFocusedParentView: $isApartmentNumberTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Postal code",
                        text: $personalInfoViewModel.newZipCode,
                        isFocusedParentView: $isZipCodeTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "City",
                        text: $personalInfoViewModel.newCity,
                        isFocusedParentView: $isCityTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Country",
                        text: $personalInfoViewModel.newCountry,
                        isFocusedParentView: $isCountryTextFieldFocused)
                    
                    HStack {
                        Text("Use as default address")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.accentColor)
                        Spacer()
                        Toggle("", isOn: $personalInfoViewModel.toBeDefaultAddress)
                            .toggleStyle(CheckMarkToggleStyle())
                    }
                    .padding(.top, 20)
                    
                }
                
                Button {
                    withAnimation {
                        profileViewModel.addNewAddress(address: personalInfoViewModel.createNewAddress(), toBeDefault: personalInfoViewModel.toBeDefaultAddress)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Add new address")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(personalInfoViewModel.newAddressFieldsNotValidated)
                .padding(.bottom, 10)
            }
            .padding()
        }
        .navigationTitle("Add new address")
    }
}

struct AddNewAddressView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let personalInfoViewModel = PersonalInfoViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                AddNewAddressView()
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
