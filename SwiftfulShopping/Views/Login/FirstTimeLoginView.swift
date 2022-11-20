//
//  FirstTimeLoginView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/09/2022.
//

import SwiftUI
import texterify_ios_sdk

struct FirstTimeLoginView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var startViewModel: StartViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var firstTimeLoginViewModel: FirstTimeLoginViewModel = FirstTimeLoginViewModel()
    @StateObject var errorManager = ErrorManager.shared
    @StateObject private var firebaseAuthManager = FirebaseAuthManager.client
    
    @State private var isFullNameTextFieldFocused: Bool = false
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
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.loggingForTheFirstTimeLabel)))
                            .font(.ssTitle1)
                        
                        Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.provideShipmentInvoiceDataInstructions)))
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                    }
                    .padding(.bottom)
                    
                    buildAddressPane()
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Button(TexterifyManager.localisedString(key: .firstTimeLoginView(.completeLoginButton))) {
                        withAnimation {
                            firstTimeLoginViewModel.showLoadingModal = true
                            firstTimeLoginViewModel.fillInvoiceData()
                            firstTimeLoginViewModel.completeFirstTimeLogin() { result in
                                firstTimeLoginViewModel.showLoadingModal = false
                                switch result {
                                case .success:
                                    break
                                case .failure(let error):
                                    ErrorManager.shared.generateCustomError(errorType: .firstTimeLoginError,
                                                                            additionalErrorDescription: error.localizedDescription)
                                }
                            }
                        }
                    }
                    .disabled(!firstTimeLoginViewModel.canCompleteLogin)
                    .buttonStyle(CustomButton())
                    .contentShape(Rectangle())
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .background {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                $firstTimeLoginViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
            .navigationTitle("")
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
                        loginViewModel.showLoadingModal = true
                        locationManager.requestLocation()
                        locationManager.getAddressDataFromLocation() { addressData in
                            firstTimeLoginViewModel.getAddressDataFromLocation(addressData: addressData)
                            loginViewModel.showLoadingModal = false
                        }
                    }, label: {
                        Image(systemName: "paperplane")
                            .foregroundColor(.accentColor)
                    })
                }
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                $loginViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
        }
    }
    
    @ViewBuilder
    func buildShipmentAddressPane() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.shipmentAddressLabel)))
                .font(.ssTitle2)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.fullNameTextField)),
                                    textFieldImageName: "person",
                                    text: $firstTimeLoginViewModel.fullName,
                                    isFocusedParentView: $isFullNameTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isFullNameValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.fullNameError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNameTextField)),
                                    text: $firstTimeLoginViewModel.streetName,
                                    isFocusedParentView: $isStreetNameTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isStreetNameValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNameError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNumberTextField)),
                                    textFieldKeyboardType: .phonePad,
                                    text: $firstTimeLoginViewModel.streetNumber,
                                    isFocusedParentView: $isStreetNumberTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isStreetNumberValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNumberError)))
                    }
                }
                
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.apartmentNumberTextField)),
                                    textFieldKeyboardType: .phonePad,
                                    text: $firstTimeLoginViewModel.apartmentNumber,
                                    isFocusedParentView: $isApartmentNumberTextFieldFocused)
                    
                    buildOptionalApartmentNumberFieldInfo()
                    
                    if !firstTimeLoginViewModel.isApartmentNumberValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.apartmentNumberError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.zipCodeTextField)),
                                    textFieldKeyboardType: .phonePad,
                                    text: $firstTimeLoginViewModel.zipCode,
                                    isFocusedParentView: $isZipCodeTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isZipCodeValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.zipCodeError)))
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.cityTextField)),
                                    text: $firstTimeLoginViewModel.city,
                                    isFocusedParentView: $isCityTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isCityNameValid {
                        buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.cityError)))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.countryLabel)))
                    .font(.ssTitle3)
                    .foregroundColor(.accentColor)
                
                SelectionDropdownMenu(selection: $firstTimeLoginViewModel.country,
                                      dataWithImagesToChoose: SelectionDropdownMenu.countries)
            }
        }
    }
    
    @ViewBuilder
    func buildInvoiceAddressPane() -> some View {
        if !firstTimeLoginViewModel.sameDataOnInvoice {
            VStack(alignment: .leading, spacing: 5) {
                Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.invoiceDataLabel)))
                    .font(.ssTitle2)
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.fullNameTextField)),
                                        textFieldImageName: "person",
                                        text: $firstTimeLoginViewModel.fullNameInvoice,
                                        isFocusedParentView: $isFullNameInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceFullNameValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.fullNameError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNameTextField)),
                                        text: $firstTimeLoginViewModel.streetNameInvoice,
                                        isFocusedParentView: $isStreetNameInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceStreetNameValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNameError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNumberTextField)),
                                        textFieldKeyboardType: .phonePad,
                                        text: $firstTimeLoginViewModel.streetNumberInvoice,
                                        isFocusedParentView: $isStreetNumberInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceStreetNumberValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.streetNumberError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.apartmentNumberTextField)),
                                        textFieldKeyboardType: .phonePad,
                                        text: $firstTimeLoginViewModel.apartmentNumberInvoice,
                                        isFocusedParentView: $isApartmentNumberInvoiceTextFieldFocused)
                        
                        buildOptionalApartmentNumberFieldInfo()
                        
                        if !firstTimeLoginViewModel.isInvoiceApartmentNumberValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.apartmentNumberError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.zipCodeTextField)),
                                        textFieldKeyboardType: .phonePad,
                                        text: $firstTimeLoginViewModel.zipCodeInvoice,
                                        isFocusedParentView: $isZipCodeInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceZipCodeValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.zipCodeError)))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .firstTimeLoginView(.cityTextField)),
                                        text: $firstTimeLoginViewModel.cityInvoice,
                                        isFocusedParentView: $isCityInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceCityNameValid {
                            buildErrorMessage(message: TexterifyManager.localisedString(key: .firstTimeLoginView(.cityError)))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.countryLabel)))
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                        
                        SelectionDropdownMenu(selection: $firstTimeLoginViewModel.countryInvoice,
                                              dataWithImagesToChoose: SelectionDropdownMenu.countries)
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
                Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.sameAddressOnInvoice)))
                    .font(.ssTitle3)
                    .foregroundColor(.accentColor)
                
                SingleSelectionToggle(selection: $firstTimeLoginViewModel.sameDataOnInvoice)
            }
            .padding(.bottom)
            
            buildInvoiceAddressPane()
        }
    }
    
    @ViewBuilder
    func buildOptionalApartmentNumberFieldInfo() -> some View {
        Text(TexterifyManager.localisedString(key: .firstTimeLoginView(.thisFieldIsOptionalLabel)))
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

struct FirstTimeLoginView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager: LocationManager = LocationManager()
        let startViewModel: StartViewModel = StartViewModel()
        let loginViewModel: LoginViewModel = LoginViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                FirstTimeLoginView()
                    .environmentObject(locationManager)
                    .environmentObject(startViewModel)
                    .environmentObject(loginViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}

