//
//  SecondRegisterView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 27/08/2022.
//

import SwiftUI

struct SecondRegisterView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var registerViewModel: RegisterViewModel
    
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
                    StepsView(stepsNumber: 2, activeStep: 2)
                        .padding(.vertical)
                    
                    VStack {
                        buildRegisterSecondPane()
                        
                        if registerViewModel.dataError {
                            HStack {
                                Text(registerViewModel.errorMessage)
                                    .font(.callout)
                                    .foregroundColor(.red)
                                    .bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Button("Register") {
                        withAnimation {
                            let (success, message) = registerViewModel.completeSecondRegistrationStep()
                            if success {
                                registerViewModel.dataError = false
                                authStateManager.didLogged()
                            } else {
                                registerViewModel.dataError = true
                                registerViewModel.errorMessage = message
                            }
                        }
                    }
                    .disabled(!registerViewModel.addressDataGiven)
                    .buttonStyle(CustomButton())
                    .contentShape(Rectangle())
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .background {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
            }
            .navigationTitle("Create Account")
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
    func buildRegisterSecondPane() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Shipment Address:")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
                
                CustomTextField(textFieldProperty: "Street Name",
                                text: $registerViewModel.streetName,
                                isFocusedParentView: $isStreetNameTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Street Number",
                                textFieldKeyboardType: .phonePad,
                                text: $registerViewModel.streetNumber,
                                isFocusedParentView: $isStreetNumberTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Apartment Number",
                                textFieldKeyboardType: .phonePad,
                                text: $registerViewModel.apartmentNumber,
                                isFocusedParentView: $isApartmentNumberTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Zip Code",
                                textFieldKeyboardType: .phonePad,
                                text: $registerViewModel.zipCode, isFocusedParentView: $isZipCodeTextFieldFocused)
                
                CustomTextField(textFieldProperty: "City",
                                text: $registerViewModel.city,
                                isFocusedParentView: $isCityTextFieldFocused)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                    
                    SelectionDropdown(selection: $registerViewModel.country,
                                      dataWithImagesToChoose: countries)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Same address on invoice?")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                    
                    SingleSelectionToggle(selection: $registerViewModel.sameDataOnInvoice)
                }
            }
            .padding(.bottom)
            
            if !registerViewModel.sameDataOnInvoice {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Invoice Data")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                        .padding(.bottom)
                    
                    CustomTextField(textFieldProperty: "First Name",
                                    textFieldImageName: "person",
                                    text: $registerViewModel.firstNameInvoice,
                                    isFocusedParentView: $isFirstNameInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Last Name",
                                    textFieldImageName: "person",
                                    text: $registerViewModel.lastNameInvoice,
                                    isFocusedParentView: $isLastNameInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Street Name",
                                    text: $registerViewModel.streetNameInvoice,
                                    isFocusedParentView: $isStreetNameInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Street Number",
                                    textFieldKeyboardType: .phonePad,
                                    text: $registerViewModel.streetNumberInvoice,
                                    isFocusedParentView: $isStreetNumberInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Apartment Number",
                                    textFieldKeyboardType: .phonePad,
                                    text: $registerViewModel.apartmentNumberInvoice,
                                    isFocusedParentView: $isApartmentNumberInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Zip Code",
                                    textFieldKeyboardType: .phonePad,
                                    text: $registerViewModel.zipCodeInvoice,
                                    isFocusedParentView: $isZipCodeInvoiceTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "City",
                                    text: $registerViewModel.cityInvoice,
                                    isFocusedParentView: $isCityInvoiceTextFieldFocused)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                    
                    SelectionDropdown(selection: $registerViewModel.countryInvoice,
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

struct SecondRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager: AuthStateManager = AuthStateManager()
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        let registerViewModel: RegisterViewModel = RegisterViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SecondRegisterView()
                    .environmentObject(authStateManager)
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
