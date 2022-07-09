//
//  PersonalInfoView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct PersonalInfoView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @StateObject private var personalInfoViewModel: PersonalInfoViewModel = PersonalInfoViewModel()
    
    @State private var isBankAccountTextFieldFocused: Bool = false
    @State private var isBankAccountHolderFirstNameTextFieldFocused: Bool = false
    @State private var isBankAccountHolderAddressTextFieldFocused: Bool = false
    @State private var isBankAccountHolderZipCodeTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCityTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCountryTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("First Name")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.firstName)
                                        .font(.system(size: 18))
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Last Name")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.lastName)
                                        .font(.system(size: 18))
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email Address")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.email)
                                        .font(.system(size: 18))
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Address")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.address.description)
                                        .font(.system(size: 18))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding()
                                    Spacer()
                                }
                            }
                            
                            Button("Add New") {
                                withAnimation {
                                    authStateManager.logoutCompletely()
                                }
                            }
                            .buttonStyle(CustomButton(buttonColor: .accentColor, imageName: "plus.circle"))
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
            
//            VStack(alignment: .leading, spacing: 40) {
//                VStack(spacing: 20) {
//                    RectangleCustomTextField(
//                        textFieldProperty: "Bank account number",
//                        textFieldFooter: "Provide 26-digits number",
//                        text: $returnCreationViewModel.bankAccountNumber,
//                        isFocusedParentView: $isBankAccountTextFieldFocused)
//
//                    RectangleCustomTextField(
//                        textFieldProperty: "Name of bank account owner",
//                        text: $returnCreationViewModel.nameOfBankAccountOwner,
//                        isFocusedParentView: $isBankAccountHolderFirstNameTextFieldFocused)
//
//                    RectangleCustomTextField(
//                        textFieldProperty: "Street and house number",
//                        text: $returnCreationViewModel.streetAndHouseNumber,
//                        isFocusedParentView: $isBankAccountHolderAddressTextFieldFocused)
//
//                    RectangleCustomTextField(
//                        textFieldProperty: "Postal code",
//                        text: $returnCreationViewModel.postalCode,
//                        isFocusedParentView: $isBankAccountHolderZipCodeTextFieldFocused)
//
//                    RectangleCustomTextField(
//                        textFieldProperty: "City",
//                        text: $returnCreationViewModel.city,
//                        isFocusedParentView: $isBankAccountHolderCityTextFieldFocused)
//
//                    RectangleCustomTextField(
//                        textFieldProperty: "Country",
//                        text: $returnCreationViewModel.country,
//                        isFocusedParentView: $isBankAccountHolderCountryTextFieldFocused)
//                }
//
//                Button("Continue") {
//                    withAnimation {
//                        shouldProceedReturnCreationView = true
//                    }
//                }
//                .buttonStyle(CustomButton())
//                .frame(width: UIScreen.main.bounds.width * 0.9)
//                .contentShape(Rectangle())
//                .padding(.bottom, 20)
//                .disabled(returnCreationViewModel.fieldsNotValidated)
//            }
//            .padding()
        }
        .navigationTitle("Create Return")
        
//        NavigationLink(destination: ThirdReturnCreationView(order: order)
//                                        .environmentObject(authStateManager)
//                                        .environmentObject(tabBarStateManager)
//                                        .environmentObject(profileViewModel)
//                                        .environmentObject(returnCreationViewModel),
//                       isActive: $shouldProceedReturnCreationView) { EmptyView() }
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                PersonalInfoView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
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
