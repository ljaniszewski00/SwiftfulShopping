//
//  SecondReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct SecondReturnCreationView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var returnCreationViewModel: ReturnCreationViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
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
                Text(TexterifyManager.localisedString(key: .secondReturnCreationView(.provideBankAccountData)))
                    .font(.ssTitle2)
                
                VStack(spacing: 20) {
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .secondReturnCreationView(.bankAccountNumberTextField)),
                        textFieldFooter: TexterifyManager.localisedString(key: .secondReturnCreationView(.bankAccountNumberTextFieldFooter)),
                        text: $returnCreationViewModel.bankAccountNumber,
                        isFocusedParentView: $isBankAccountTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .secondReturnCreationView(.bankAccountOwnerNameTextField)),
                        text: $returnCreationViewModel.nameOfBankAccountOwner,
                        isFocusedParentView: $isBankAccountHolderFirstNameTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .secondReturnCreationView(.streetHouseNumberTextField)),
                        text: $returnCreationViewModel.streetAndHouseNumber,
                        isFocusedParentView: $isBankAccountHolderAddressTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .secondReturnCreationView(.postalCodeTextField)),
                        text: $returnCreationViewModel.postalCode,
                        isFocusedParentView: $isBankAccountHolderZipCodeTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .secondReturnCreationView(.cityTextField)),
                        text: $returnCreationViewModel.city,
                        isFocusedParentView: $isBankAccountHolderCityTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .secondReturnCreationView(.countryTextField)),
                        text: $returnCreationViewModel.country,
                        isFocusedParentView: $isBankAccountHolderCountryTextFieldFocused)
                }
                
                Button {
                    withAnimation {
                        returnCreationViewModel.shouldPresentThirdReturnCreationView = true
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .secondReturnCreationView(.continueButton)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(returnCreationViewModel.fieldsNotValidated)
            }
            .padding()
        }
        .navigationTitle(TexterifyManager.localisedString(key: .secondReturnCreationView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
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
        
        NavigationLink(destination: ThirdReturnCreationView()
                                        .environmentObject(returnCreationViewModel),
                       isActive: $returnCreationViewModel.shouldPresentThirdReturnCreationView) { EmptyView() }
            .isDetailLink(false)
    }
}

struct SecondReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let returnCreationViewModel = ReturnCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SecondReturnCreationView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(returnCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
