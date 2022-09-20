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
    
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    @State private var isFirstNameInvoiceTextFieldFocused: Bool = false
    @State private var isLastNameInvoiceTextFieldFocused: Bool = false
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
                            let (success, message) = loginViewModel.completeAddressProviding()
                            if success {
                                authStateManager.didLogged(with: .emailPassword)
                            } else {
                                errorManager.generateCustomError(errorType: .loginError,
                                                                 additionalErrorDescription: message)
                            }
                        }
                    }
                    .disabled(!loginViewModel.addressDataGiven)
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
                            loginViewModel.getAddressDataFromLocation(addressData: addressData)
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
    func buildAddressPane() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Shipment Address:")
                    .font(.ssTitle2)
                    .foregroundColor(.accentColor)
                
                CustomTextField(textFieldProperty: "Street Name",
                                text: $loginViewModel.streetName,
                                isFocusedParentView: $isStreetNameTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Street Number",
                                textFieldKeyboardType: .phonePad,
                                text: $loginViewModel.streetNumber,
                                isFocusedParentView: $isStreetNumberTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Apartment Number",
                                textFieldKeyboardType: .phonePad,
                                text: $loginViewModel.apartmentNumber,
                                isFocusedParentView: $isApartmentNumberTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Zip Code",
                                textFieldKeyboardType: .phonePad,
                                text: $loginViewModel.zipCode, isFocusedParentView: $isZipCodeTextFieldFocused)
                
                CustomTextField(textFieldProperty: "City",
                                text: $loginViewModel.city,
                                isFocusedParentView: $isCityTextFieldFocused)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country:")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                    
                    SelectionDropdownMenu(selection: $loginViewModel.country,
                                      dataWithImagesToChoose: countries)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Same address on invoice?")
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                    
                    SingleSelectionToggle(selection: $loginViewModel.sameDataOnInvoice)
                }
            }
            .padding(.bottom)
            
            if !loginViewModel.sameDataOnInvoice {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Invoice Data")
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                        .padding(.bottom)
                    
                    CustomTextField(textFieldProperty: "First Name",
                                    textFieldImageName: "person",
                                    text: $loginViewModel.firstNameInvoice,
                                    isFocusedParentView: $isFirstNameInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Last Name",
                                    textFieldImageName: "person",
                                    text: $loginViewModel.lastNameInvoice,
                                    isFocusedParentView: $isLastNameInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Street Name",
                                    text: $loginViewModel.streetNameInvoice,
                                    isFocusedParentView: $isStreetNameInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Street Number",
                                    textFieldKeyboardType: .phonePad,
                                    text: $loginViewModel.streetNumberInvoice,
                                    isFocusedParentView: $isStreetNumberInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Apartment Number",
                                    textFieldKeyboardType: .phonePad,
                                    text: $loginViewModel.apartmentNumberInvoice,
                                    isFocusedParentView: $isApartmentNumberInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Zip Code",
                                    textFieldKeyboardType: .phonePad,
                                    text: $loginViewModel.zipCodeInvoice,
                                    isFocusedParentView: $isZipCodeInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "City",
                                    text: $loginViewModel.cityInvoice,
                                    isFocusedParentView: $isCityInvoiceTextFieldFocused)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country:")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                    
                    SelectionDropdownMenu(selection: $loginViewModel.countryInvoice,
                                      dataWithImagesToChoose: countries)
                }
            }
        }
    }
    
    private let countries: [String: String?] = ["Czech": "czech",
                                                "England": "england",
                                                "France": "france",
                                                "Germany": "germany",
                                                "Poland": "poland",
                                                "Spain": "spain",
                                                "United States": "united"]
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

