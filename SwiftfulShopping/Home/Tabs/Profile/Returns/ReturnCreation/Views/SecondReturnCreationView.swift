//
//  SecondReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI

struct SecondReturnCreationView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var returnCreationViewModel: ReturnCreationViewModel
    
    @State private var isBankAccountTextFieldFocused: Bool = false
    @State private var isBankAccountHolderFirstNameTextFieldFocused: Bool = false
    @State private var isBankAccountHolderAddressTextFieldFocused: Bool = false
    @State private var isBankAccountHolderZipCodeTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCityTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCountryTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 40) {
                StepsView(stepsNumber: 4, activeStep: 2)
                
                Text("Provide bank account data to get your money back")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                
                VStack(spacing: 20) {
                    RectangleCustomTextField(
                        textFieldProperty: "Bank account number",
                        textFieldFooter: "Provide 26-digits number",
                        text: $returnCreationViewModel.bankAccountNumber,
                        isFocusedParentView: $isBankAccountTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Name of bank account owner",
                        text: $returnCreationViewModel.nameOfBankAccountOwner,
                        isFocusedParentView: $isBankAccountHolderFirstNameTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Street and house number",
                        text: $returnCreationViewModel.streetAndHouseNumber,
                        isFocusedParentView: $isBankAccountHolderAddressTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Postal code",
                        text: $returnCreationViewModel.postalCode,
                        isFocusedParentView: $isBankAccountHolderZipCodeTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "City",
                        text: $returnCreationViewModel.city,
                        isFocusedParentView: $isBankAccountHolderCityTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Country",
                        text: $returnCreationViewModel.country,
                        isFocusedParentView: $isBankAccountHolderCountryTextFieldFocused)
                }
                
                Button {
                    withAnimation {
                        returnCreationViewModel.shouldPresentThirdReturnCreationView = true
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .contentShape(Rectangle())
                .padding(.bottom, 20)
                .disabled(returnCreationViewModel.fieldsNotValidated)
            }
            .padding()
        }
        .navigationTitle("Create Return")
        
        NavigationLink(destination: ThirdReturnCreationView()
                                        .environmentObject(authStateManager)
                                        .environmentObject(tabBarStateManager)
                                        .environmentObject(profileViewModel)
                                        .environmentObject(returnCreationViewModel),
                       isActive: $returnCreationViewModel.shouldPresentThirdReturnCreationView) { EmptyView() }
    }
}

struct SecondReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let returnCreationViewModel = ReturnCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SecondReturnCreationView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(returnCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        returnCreationViewModel.orderForReturn = Order.demoOrders[0]
                    }
            }
        }
    }
}
