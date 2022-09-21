//
//  FirstTimeLoginView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/09/2022.
//

import SwiftUI

struct FirstTimeLoginView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var firstTimeLoginViewModel: FirstTimeLoginViewModel = FirstTimeLoginViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
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
                        Text("Logging for the first time?")
                            .font(.ssTitle1)
                            
                        
                        Text("Please provide shipment and invoice information to speed up order process. You will be able to change it in your profile later.")
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                    }
                    .padding(.bottom)
                    
                    buildAddressPane()
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Button("Complete Login") {
                        withAnimation {
                            firstTimeLoginViewModel.fillInvoiceData()
                            loginViewModel.addressProvidingCompletion() { success in
                                if let signInMethod = authStateManager.loggedWith {
                                    authStateManager.didLogged(with: signInMethod)
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
            Text("Shipment Address:")
                .font(.ssTitle2)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: "Full Name",
                                    textFieldImageName: "person",
                                    text: $firstTimeLoginViewModel.fullName,
                                    isFocusedParentView: $isFullNameTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isFullNameValid {
                        buildErrorMessage(message: "Full name should not contain any numbers and has to consist of at least two words.")
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: "Street Name",
                                    text: $firstTimeLoginViewModel.streetName,
                                    isFocusedParentView: $isStreetNameTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isStreetNameValid {
                        buildErrorMessage(message: "Street name should not contain any numbers")
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: "Street Number",
                                    textFieldKeyboardType: .phonePad,
                                    text: $firstTimeLoginViewModel.streetNumber,
                                    isFocusedParentView: $isStreetNumberTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isStreetNumberValid {
                        buildErrorMessage(message: "Street number should contain only numbers.")
                    }
                }
                
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: "Apartment Number",
                                    textFieldKeyboardType: .phonePad,
                                    text: $firstTimeLoginViewModel.apartmentNumber,
                                    isFocusedParentView: $isApartmentNumberTextFieldFocused)
                    
                    buildOptionalApartmentNumberFieldInfo()
                    
                    if !firstTimeLoginViewModel.isApartmentNumberValid {
                        buildErrorMessage(message: "Apartment number should contain only numbers.")
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: "Zip Code",
                                    textFieldKeyboardType: .phonePad,
                                    text: $firstTimeLoginViewModel.zipCode,
                                    isFocusedParentView: $isZipCodeTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isZipCodeValid {
                        buildErrorMessage(message: "Zip Code should contain only 5 digits and be formatted like XXXXX.")
                    }
                }
                
                VStack(alignment: .leading) {
                    CustomTextField(textFieldProperty: "City",
                                    text: $firstTimeLoginViewModel.city,
                                    isFocusedParentView: $isCityTextFieldFocused)
                    
                    if !firstTimeLoginViewModel.isCityNameValid {
                        buildErrorMessage(message: "City name should not contain any numbers.")
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Country:")
                    .font(.ssTitle3)
                    .foregroundColor(.accentColor)
                
                SelectionDropdownMenu(selection: $firstTimeLoginViewModel.country,
                                      dataWithImagesToChoose: firstTimeLoginViewModel.countries)
            }
        }
    }
    
    @ViewBuilder
    func buildInvoiceAddressPane() -> some View {
        if !firstTimeLoginViewModel.sameDataOnInvoice {
            VStack(alignment: .leading, spacing: 5) {
                Text("Invoice Data")
                    .font(.ssTitle2)
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: "Full Name",
                                        textFieldImageName: "person",
                                        text: $firstTimeLoginViewModel.fullNameInvoice,
                                        isFocusedParentView: $isFullNameInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceFullNameValid {
                            buildErrorMessage(message: "Full name should not contain any numbers and has to consist of at least two words.")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: "Street Name",
                                        text: $firstTimeLoginViewModel.streetNameInvoice,
                                        isFocusedParentView: $isStreetNameInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceStreetNameValid {
                            buildErrorMessage(message: "Street name should not contain any numbers")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: "Street Number",
                                        textFieldKeyboardType: .phonePad,
                                        text: $firstTimeLoginViewModel.streetNumberInvoice,
                                        isFocusedParentView: $isStreetNumberInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceStreetNumberValid {
                            buildErrorMessage(message: "Street number should contain only numbers.")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: "Apartment Number",
                                        textFieldKeyboardType: .phonePad,
                                        text: $firstTimeLoginViewModel.apartmentNumberInvoice,
                                        isFocusedParentView: $isApartmentNumberInvoiceTextFieldFocused)
                        
                        buildOptionalApartmentNumberFieldInfo()
                        
                        if !firstTimeLoginViewModel.isInvoiceApartmentNumberValid {
                            buildErrorMessage(message: "Apartment number should contain only numbers.")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: "Zip Code",
                                        textFieldKeyboardType: .phonePad,
                                        text: $firstTimeLoginViewModel.zipCodeInvoice,
                                        isFocusedParentView: $isZipCodeInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceZipCodeValid {
                            buildErrorMessage(message: "Zip Code should contain only 5 digits and be formatted like XXXXX.")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        CustomTextField(textFieldProperty: "City",
                                        text: $firstTimeLoginViewModel.cityInvoice,
                                        isFocusedParentView: $isCityInvoiceTextFieldFocused)
                        
                        if !firstTimeLoginViewModel.isInvoiceCityNameValid {
                            buildErrorMessage(message: "City name should not contain any numbers.")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Country:")
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                        
                        SelectionDropdownMenu(selection: $firstTimeLoginViewModel.countryInvoice,
                                              dataWithImagesToChoose: firstTimeLoginViewModel.countries)
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
                Text("Same address on invoice?")
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
        Text("This field is optional.")
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
        let authStateManager: AuthStateManager = AuthStateManager()
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        let loginViewModel: LoginViewModel = LoginViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                FirstTimeLoginView()
                    .environmentObject(authStateManager)
                    .environmentObject(locationManager)
                    .environmentObject(contentViewModel)
                    .environmentObject(loginViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}

