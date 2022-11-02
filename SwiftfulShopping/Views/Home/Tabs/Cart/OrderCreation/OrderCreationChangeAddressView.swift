//
//  OrderCreationChangeAddressView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrderCreationChangeAddressView: View {
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var addressSectionExpanded: Bool = false
    
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.chooseFromExisting)))
                            .font(.ssTitle2)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.address)))
                                .font(.ssCallout)
                                .foregroundColor(.accentColor)
                            
                            SelectionDropdownMenu(selection: $orderCreationViewModel.defaultAddress,
                                                  dataWithImagesToChoose: orderCreationViewModel.addresses,
                                                  includeSearchField: false)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            dismiss()
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.save)))
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                    .contentShape(Rectangle())
                }
                
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.createNewOne)))
                            .font(.ssTitle2)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            RectangleCustomTextField(
                                textFieldProperty: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.streetName)),
                                text: $orderCreationViewModel.newStreetName,
                                isFocusedParentView: $isStreetNameTextFieldFocused)
                            
                            RectangleCustomTextField(
                                textFieldProperty: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.streetNumber)),
                                text: $orderCreationViewModel.newStreetNumber,
                                isFocusedParentView: $isStreetNumberTextFieldFocused)
                            
                            RectangleCustomTextField(
                                textFieldProperty: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.apartmentNumber)),
                                textFieldFooter: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.apartmentNumberThisFieldIsOptional)),
                                text: $orderCreationViewModel.newApartmentNumber,
                                isFocusedParentView: $isApartmentNumberTextFieldFocused)
                            
                            RectangleCustomTextField(
                                textFieldProperty: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.postalCode)),
                                text: $orderCreationViewModel.newZipCode,
                                isFocusedParentView: $isZipCodeTextFieldFocused)
                            
                            RectangleCustomTextField(
                                textFieldProperty: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.city)),
                                text: $orderCreationViewModel.newCity,
                                isFocusedParentView: $isCityTextFieldFocused)
                            
                            RectangleCustomTextField(
                                textFieldProperty: TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.country)),
                                text: $orderCreationViewModel.newCountry,
                                isFocusedParentView: $isCountryTextFieldFocused)
                        }
                        .padding(.bottom, 15)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.wouldYouLikeToSaveThisAddress)))
                                .font(.ssTitle3)
                            
                            SingleSelectionToggle(selection: $orderCreationViewModel.addressToBeSaved)
                        }
                        
                        if orderCreationViewModel.addressToBeSaved {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.wouldYouLikeAddressDefault)))
                                    .font(.ssTitle3)
                                
                                SingleSelectionToggle(selection: $orderCreationViewModel.addressToBeDefault)
                            }
                        }
                    }
                    
                    Button {
                        withAnimation {
                            if let address = orderCreationViewModel.createNewAddress() {
                                if orderCreationViewModel.addressToBeSaved {
                                    profileViewModel.addNewAddress(address: address, toBeDefault: orderCreationViewModel.addressToBeDefault) { result in
                                        switch result {
                                        case .success:
                                            dismiss()
                                        case .failure(let error):
                                            ErrorManager.shared.generateCustomError(errorType: .createAddressError,
                                                                                    additionalErrorDescription: error.localizedDescription)
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.addNewAddressButton)))
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                    .contentShape(Rectangle())
                    .disabled(orderCreationViewModel.newAddressFieldsNotValidated)
                }
            }
            .padding()
        }
        .navigationTitle(TexterifyManager.localisedString(key: .orderCreationChangeAddressView(.navigationTitle)))
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
    }
}

struct OrderCreationChangeAddressView_Previews: PreviewProvider {
    static var previews: some View {
        let profileViewModel = ProfileViewModel()
        let orderCreationViewModel = OrderCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationChangeAddressView()
                    .environmentObject(profileViewModel)
                    .environmentObject(orderCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        if let profile = profileViewModel.profile {
                            orderCreationViewModel.setupAddresses(defaultProfileAddress:
                                                                    profile.defaultShipmentAddress,
                                                                  profileAddresses:
                                                                    profile.shipmentAddresses)
                            
                            if orderCreationViewModel.choosenShippingMethod == nil {
                                orderCreationViewModel.choosenShippingMethod = profile.defaultShippingMethod
                            }
                            
                            if orderCreationViewModel.choosenPaymentMethod == nil {
                                orderCreationViewModel.choosenPaymentMethod = profile.defaultPaymentMethod
                            }
                        }
                    }
            }
        }
    }
}
