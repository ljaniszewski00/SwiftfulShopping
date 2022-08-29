//
//  OrderCreationChangeAddressView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import SwiftUI

struct OrderCreationChangeAddressView: View {
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var addressSectionExpanded: Bool = false
    
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Choose from existing")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Address")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        
                        SelectionDropdownMenu(selection: $orderCreationViewModel.defaultAddress,
                                              dataWithImagesToChoose: orderCreationViewModel.addresses,
                                              includeSearchField: false)
                    }
                }
                
                Button {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Save")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Create new one")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        RectangleCustomTextField(
                            textFieldProperty: "Street Name",
                            text: $orderCreationViewModel.newStreetName,
                            isFocusedParentView: $isStreetNameTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: "Street Number",
                            text: $orderCreationViewModel.newStreetNumber,
                            isFocusedParentView: $isStreetNumberTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: "Apartment Number",
                            textFieldFooter: "This field is optional",
                            text: $orderCreationViewModel.newApartmentNumber,
                            isFocusedParentView: $isApartmentNumberTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: "Postal code",
                            text: $orderCreationViewModel.newZipCode,
                            isFocusedParentView: $isZipCodeTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: "City",
                            text: $orderCreationViewModel.newCity,
                            isFocusedParentView: $isCityTextFieldFocused)
                        
                        RectangleCustomTextField(
                            textFieldProperty: "Country",
                            text: $orderCreationViewModel.newCountry,
                            isFocusedParentView: $isCountryTextFieldFocused)
                    }
                    .padding(.bottom, 15)
                    
                    HStack {
                        Text("Would you like to save this address?")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                        
                        Spacer()
                        
                        Toggle("", isOn: $orderCreationViewModel.addressToBeSaved)
                            .toggleStyle(CheckMarkToggleStyle())
                            .padding(.trailing, 10)
                    }
                    
                    if orderCreationViewModel.addressToBeSaved {
                        HStack {
                            Text("Would you like this address to be default?")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                            
                            Spacer()
                            
                            Toggle("", isOn: $orderCreationViewModel.addressToBeDefault)
                                .toggleStyle(CheckMarkToggleStyle())
                                .padding(.trailing, 10)
                        }
                    }
                }
                
                Button {
                    withAnimation {
                        let createdAddress = orderCreationViewModel.createNewAddress()
                        if orderCreationViewModel.addressToBeSaved {
                            profileViewModel.addNewAddress(address: createdAddress, toBeDefault: orderCreationViewModel.addressToBeDefault)
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Add new address")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(orderCreationViewModel.newAddressFieldsNotValidated)
            }
            .padding()
        }
        .navigationTitle("Change delivery address")
        .navigationBarTitleDisplayMode(.inline)
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
                        orderCreationViewModel.setupAddresses(defaultProfileAddress:
                                                                profileViewModel.profile.defaultAddress,
                                                              profileAddresses:
                                                                profileViewModel.profile.addresses)
                        
                        if orderCreationViewModel.choosenShippingMethod == nil {
                            orderCreationViewModel.choosenShippingMethod = profileViewModel.profile.defaultShippingMethod
                        }
                        
                        if orderCreationViewModel.choosenPaymentMethod == nil {
                            orderCreationViewModel.choosenPaymentMethod = profileViewModel.profile.defaultPaymentMethod
                        }
                    }
            }
        }
    }
}
