//
//  AddNewAddressView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct AddNewAddressView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var personalInfoViewModel: PersonalInfoViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject var errorManager = ErrorManager()
    
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 20) {
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .addNewAddressView(.streetNameTextField)),
                            text: $personalInfoViewModel.newStreetName,
                            isFocusedParentView: $isStreetNameTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .addNewAddressView(.streetNumberTextField)),
                            text: $personalInfoViewModel.newStreetNumber,
                            isFocusedParentView: $isStreetNumberTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .addNewAddressView(.apartmentNumberTextField)),
                            textFieldFooter: TexterifyManager.localisedString(key: .addNewAddressView(.thisFieldIsOptional)),
                            text: $personalInfoViewModel.newApartmentNumber,
                            isFocusedParentView: $isApartmentNumberTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .addNewAddressView(.postalCodeTextField)),
                            text: $personalInfoViewModel.newZipCode,
                            isFocusedParentView: $isZipCodeTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: TexterifyManager.localisedString(key: .addNewAddressView(.cityTextField)),
                            text: $personalInfoViewModel.newCity,
                            isFocusedParentView: $isCityTextFieldFocused)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(TexterifyManager.localisedString(key: .addNewAddressView(.countryTextField)))
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                            
                            SelectionDropdownMenu(selection: $personalInfoViewModel.newCountry,
                                                  dataWithImagesToChoose: personalInfoViewModel.countries)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .addNewAddressView(.useAsDefaultAddress)))
                            .font(.ssTitle2)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.accentColor)
                        SingleSelectionToggle(selection: $personalInfoViewModel.toBeDefaultAddress)
                    }
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
                    Text(TexterifyManager.localisedString(key: .addNewAddressView(.addNewAddressButton)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(personalInfoViewModel.newAddressFieldsNotValidated)
            }
            .padding()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $personalInfoViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                             customError: errorManager.customError ?? ErrorManager.unknownError))
        .navigationTitle(TexterifyManager.localisedString(key: .addNewAddressView(.navigationTitle)))
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

struct AddNewAddressView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let personalInfoViewModel = PersonalInfoViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                AddNewAddressView()
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
