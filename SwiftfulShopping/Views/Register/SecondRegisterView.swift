//
//  SecondRegisterView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 27/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct SecondRegisterView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var registerViewModel: RegisterViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var errorManager = ErrorManager.shared
    @StateObject private var firebaseAuthManager = FirebaseAuthManager.client
    
    @State private var isFullNameShipmentTextFieldFocused: Bool = false
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    @State private var isFullNameInvoiceTextFieldFocused: Bool = false
    @State private var isStreetNameInvoiceTextFieldFocused: Bool = false
    @State private var isStreetNumberInvoiceTextFieldFocused: Bool = false
    @State private var isApartmentNumberInvoiceTextFieldFocused: Bool = false
    @State private var isZipCodeInvoiceTextFieldFocused: Bool = false
    @State private var isCityInvoiceTextFieldFocused: Bool = false
    @State private var isCountryInvoiceTextFieldFocused: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    StepsView(stepsNumber: 2, activeStep: 2)
                        .padding(.bottom)
                    
                    buildAddressPane()
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Button(TexterifyManager.localisedString(key: .secondRegisterView(.registerButton))) {
                        withAnimation {
                            registerViewModel.showLoadingModal = true
                            
                            FirebaseAuthManager.client.firebaseSignUp(email: registerViewModel.email,
                                                                      password: registerViewModel.password) { result in
                                switch result {
                                case .success:
                                    registerViewModel.completeRegistration() { result in
                                        registerViewModel.showLoadingModal = false
                                        switch result {
                                        case .success:
                                            firebaseAuthManager.loggedWith = .emailPassword
                                        case .failure(let error):
                                            ErrorManager.shared.generateCustomError(errorType: .registerError,
                                                                                    additionalErrorDescription: error.localizedDescription)
                                        }
                                    }
                                case .failure(let error):
                                    registerViewModel.showLoadingModal = false
                                    ErrorManager.shared.generateCustomError(errorType: .registerError,
                                                                            additionalErrorDescription: error.localizedDescription)
                                }
                            }
                        }
                    }
                    .disabled(!registerViewModel.canCompleteRegistration)
                    .buttonStyle(CustomButton())
                    .contentShape(Rectangle())
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .background {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
            }
            .navigationTitle(TexterifyManager.localisedString(key: .secondRegisterView(.navigationTitle)))
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.accentColor)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        registerViewModel.showLoadingModal = true
                        locationManager.requestLocation()
                        locationManager.getAddressDataFromLocation() { addressData in
                            registerViewModel.getAddressDataFromLocation(addressData: addressData)
                            registerViewModel.showLoadingModal = false
                        }
                    }, label: {
                        Image(systemName: "paperplane")
                            .foregroundColor(.accentColor)
                    })
                }
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                $registerViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
        }
    }
    
    @ViewBuilder
    func buildShipmentAddressPane() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(TexterifyManager.localisedString(key: .secondRegisterView(.shipmentAddressLabel)))
                .font(.ssTitle2)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.fullNameTextField)),
                                    textFieldImageName: "person",
                                    text: $registerViewModel.fullName,
                                    isFocusedParentView: $isFullNameShipmentTextFieldFocused)
                    
                    if !registerViewModel.isFullNameShipmentValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.fullNameError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.streetNameTextField)),
                                    text: $registerViewModel.streetName,
                                    isFocusedParentView: $isStreetNameTextFieldFocused)
                    
                    if !registerViewModel.isStreetNameValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.streetNameError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.streetNumberTextField)),
                                    textFieldKeyboardType: .phonePad,
                                    text: $registerViewModel.streetNumber,
                                    isFocusedParentView: $isStreetNumberTextFieldFocused)
                    
                    if !registerViewModel.isStreetNumberValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.streetNumberError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.apartmentNumberTextField)),
                                    textFieldKeyboardType: .phonePad,
                                    text: $registerViewModel.apartmentNumber,
                                    isFocusedParentView: $isApartmentNumberTextFieldFocused)
                    
                    buildOptionalApartmentNumberFieldInfo()
                    
                    if !registerViewModel.isApartmentNumberValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.apartmentNumberError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.zipCodeTextField)),
                                    textFieldKeyboardType: .phonePad,
                                    text: $registerViewModel.zipCode,
                                    isFocusedParentView: $isZipCodeTextFieldFocused)
                    
                    if !registerViewModel.isZipCodeValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.zipCodeError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.cityTextField)),
                                    text: $registerViewModel.city,
                                    isFocusedParentView: $isCityTextFieldFocused)
                    
                    if !registerViewModel.isCityNameValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.cityError)))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(TexterifyManager.localisedString(key: .secondRegisterView(.countryLabel)))
                    .font(.ssTitle3)
                    .foregroundColor(.accentColor)
                
                SelectionDropdownMenu(selection: $registerViewModel.country,
                                      dataWithImagesToChoose: registerViewModel.countries)
            }
        }
    }
    
    @ViewBuilder
    func buildInvoiceAddressPane() -> some View {
        if !registerViewModel.sameDataOnInvoice {
            VStack(alignment: .leading, spacing: 5) {
                Text(TexterifyManager.localisedString(key: .secondRegisterView(.invoiceDataLabel)))
                    .font(.ssTitle2)
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.fullNameTextField)),
                                        textFieldImageName: "person",
                                        text: $registerViewModel.fullNameInvoice,
                                        isFocusedParentView: $isFullNameInvoiceTextFieldFocused)
                        
                        if !registerViewModel.isInvoiceFullNameValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.fullNameError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.streetNameTextField)),
                                        text: $registerViewModel.streetNameInvoice,
                                        isFocusedParentView: $isStreetNameInvoiceTextFieldFocused)
                        
                        if !registerViewModel.isInvoiceStreetNameValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.streetNameError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.streetNumberTextField)),
                                        textFieldKeyboardType: .phonePad,
                                        text: $registerViewModel.streetNumberInvoice,
                                        isFocusedParentView: $isStreetNumberInvoiceTextFieldFocused)
                        
                        if !registerViewModel.isInvoiceStreetNumberValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.streetNumberError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.apartmentNumberTextField)),
                                        textFieldKeyboardType: .phonePad,
                                        text: $registerViewModel.apartmentNumberInvoice,
                                        isFocusedParentView: $isApartmentNumberInvoiceTextFieldFocused)
                        
                        buildOptionalApartmentNumberFieldInfo()
                        
                        if !registerViewModel.isInvoiceApartmentNumberValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.apartmentNumberError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.zipCodeTextField)),
                                        textFieldKeyboardType: .phonePad,
                                        text: $registerViewModel.zipCodeInvoice,
                                        isFocusedParentView: $isZipCodeInvoiceTextFieldFocused)
                        
                        if !registerViewModel.isInvoiceZipCodeValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.zipCodeError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .secondRegisterView(.cityTextField)),
                                        text: $registerViewModel.cityInvoice,
                                        isFocusedParentView: $isCityInvoiceTextFieldFocused)
                        
                        if !registerViewModel.isInvoiceCityNameValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .secondRegisterView(.cityError)))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .secondRegisterView(.countryLabel)))
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                        
                        SelectionDropdownMenu(selection: $registerViewModel.countryInvoice,
                                              dataWithImagesToChoose: registerViewModel.countries)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func buildAddressPane() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            buildShipmentAddressPane()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(TexterifyManager.localisedString(key: .secondRegisterView(.sameAddressOnInvoice)))
                    .font(.ssTitle3)
                    .foregroundColor(.accentColor)
                
                SingleSelectionToggle(selection: $registerViewModel.sameDataOnInvoice)
            }
            .padding(.bottom)
            
            buildInvoiceAddressPane()
        }
    }
    
    @ViewBuilder
    func buildOptionalApartmentNumberFieldInfo() -> some View {
        Text(TexterifyManager.localisedString(key: .secondRegisterView(.thisFieldIsOptionalLabel)))
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.ssDarkGray)
            .padding(.bottom, 5)
    }
    
    @ViewBuilder
    func buildErrorMessage(message: String) -> some View {
        Text(message)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.red)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct SecondRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        let registerViewModel: RegisterViewModel = RegisterViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SecondRegisterView()
                    .environmentObject(locationManager)
                    .environmentObject(contentViewModel)
                    .environmentObject(registerViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
