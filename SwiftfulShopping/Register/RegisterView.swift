//
//  RegisterView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI
import CoreLocationUI

struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var locationManager: LocationManager
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isFirstNameTextFieldFocused: Bool = false
    @State private var isLastNameTextFieldFocused: Bool = false
    @State private var isUsernameTextFieldFocused: Bool = false
    
    @State private var isEmailTextFieldFocused: Bool = false
    @State private var isPasswordTextFieldFocused: Bool = false
    
    @State private var isStreetNameTextFieldFocused: Bool = false
    @State private var isStreetNumberTextFieldFocused: Bool = false
    @State private var isApartmentNumberTextFieldFocused: Bool = false
    @State private var isZipCodeTextFieldFocused: Bool = false
    @State private var isCityTextFieldFocused: Bool = false
    @State private var isCountryTextFieldFocused: Bool = false
    
    @State private var presentSecondRegisterView: Bool = false
    
    @State private var dataError: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var showPasswordHint: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        if !presentSecondRegisterView {
                            firstPane()
                                .transition(.slide)
                        } else {
                            secondPane()
                                .transition(.move(edge: .leading))
                        }
                        
                        if dataError {
                            HStack {
                                Text(errorMessage)
                                    .font(.callout)
                                    .foregroundColor(.red)
                                    .bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button(presentSecondRegisterView ? "Register" : "Next") {
                            withAnimation {
                                if presentSecondRegisterView {
                                    let (success, message) = registerViewModel.completeSecondRegistrationStep()
                                    if success {
                                        dataError = false
                                        authStateManager.didLogged()
                                    } else {
                                        dataError = true
                                        errorMessage = message
                                    }
                                } else {
                                    let (success, message) = registerViewModel.completeFirstRegistrationStep()
                                    if success {
                                        dataError = false
                                        presentSecondRegisterView = true
                                    } else {
                                        dataError = true
                                        errorMessage = message
                                    }
                                }
                            }
                        }
                        .disabled(registerViewModel.checkPersonalDataFieldsEmpty())
                        .buttonStyle(CustomButton())
                        .contentShape(Rectangle())
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
                .frame(minHeight: geometry.size.height)
            }
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
                        .foregroundColor(.black)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    registerViewModel.fillPersonalData()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.black)
                })
            }
        }
        .background(Color.backgroundColor.ignoresSafeArea())
    }
    
    @ViewBuilder
    func firstPane() -> some View {
        VStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Personal Information:")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .padding(.bottom)
                    
                    CustomTextField(textFieldProperty: "First Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.firstName, isFocusedParentView: $isFirstNameTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Last Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.lastName, isFocusedParentView: $isLastNameTextFieldFocused)
                    
                    CustomTextField(textFieldProperty: "Username", textFieldImageName: "person", textFieldSignsLimit: 20, text: $registerViewModel.username, isFocusedParentView: $isUsernameTextFieldFocused)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Birth Date:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    CustomDatePicker(includeDayPicking: true, datePicked: $registerViewModel.birthDate)
                }
            }
            .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Credentials:")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .padding(.bottom)
                
                CustomTextField(textFieldProperty: "E-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $registerViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
                
                VStack(alignment: .trailing, spacing: 10) {
                    CustomTextField(isSecureField: true, textFieldProperty: "Password", textFieldImageName: "lock", text: $registerViewModel.password, isFocusedParentView: $isPasswordTextFieldFocused)
                    
                    HStack {
                        if showPasswordHint {
                            Text("Password should be at least 8 characters long and should contain a number.")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(dataError ? .red : .gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(dataError ? .red : showPasswordHint ? .accentColor : .gray)
                            .onTapGesture {
                                withAnimation {
                                    showPasswordHint.toggle()
                                }
                            }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func secondPane() -> some View {
        VStack(spacing: -10) {
            Text("Please provide shipment data:")
                .font(.callout)
                .foregroundColor(.gray)
                .bold()
                .padding(.vertical)
            
            Button("Use Current Location") {
                withAnimation() {
                    locationManager.requestLocation()
                    locationManager.getAddressDataFromLocation() { addressData in
                        registerViewModel.getAddressDataFromLocation(addressData: addressData)
                    }
                }
            }
            .buttonStyle(CustomButton(imageName: "paperplane"))
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .contentShape(Rectangle())
            .padding(.vertical)
            
            CustomTextField(textFieldProperty: "Street Name", textFieldSignsLimit: 30, text: $registerViewModel.streetName, isFocusedParentView: $isStreetNameTextFieldFocused)
            
            CustomTextField(textFieldProperty: "Street Number", textFieldKeyboardType: .phonePad, textFieldSignsLimit: 4, text: $registerViewModel.streetNumber, isFocusedParentView: $isStreetNumberTextFieldFocused)
            
            CustomTextField(textFieldProperty: "Apartment Number", textFieldKeyboardType: .phonePad, textFieldSignsLimit: 4, text: $registerViewModel.apartmentNumber, isFocusedParentView: $isApartmentNumberTextFieldFocused)
            
            CustomTextField(textFieldProperty: "Zip Code", textFieldKeyboardType: .phonePad, textFieldSignsLimit: 6, text: $registerViewModel.zipCode, isFocusedParentView: $isZipCodeTextFieldFocused)
            
            CustomTextField(textFieldProperty: "City", textFieldSignsLimit: 20, text: $registerViewModel.city, isFocusedParentView: $isCityTextFieldFocused)
            
            HStack {
                Text("Country: ")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .bold()
                
                Picker(selection: $registerViewModel.country, label: Text("")) {
                    ForEach(Array(possibleCuntriesDictionary.values), id: \.self) { country in
                        Text(country)
                    }
                }
                .labelsHidden()
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor, lineWidth: 1))

                VStack(spacing: 10) {
                    Text("Same Data on Invoice")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                    Toggle("", isOn: $registerViewModel.sameDataOnInvoice)
                        .toggleStyle(CheckMarkToggleStyle())
                }
                .padding(.leading, 30)
            }
            .padding()
            .padding(.bottom, 20)
            
            if !registerViewModel.sameDataOnInvoice {
                Text("Please provide invoice data:")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .bold()
                    .padding(.vertical)
                
                CustomTextField(textFieldProperty: "First Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.firstNameInvoice, isFocusedParentView: $isFirstNameTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Last Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.lastNameInvoice, isFocusedParentView: $isLastNameTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Street Name", textFieldSignsLimit: 30, text: $registerViewModel.streetNameInvoice, isFocusedParentView: $isStreetNameTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Street Number", textFieldKeyboardType: .phonePad, textFieldSignsLimit: 4, text: $registerViewModel.streetNumberInvoice, isFocusedParentView: $isStreetNumberTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Apartment Number", textFieldKeyboardType: .phonePad, textFieldSignsLimit: 4, text: $registerViewModel.apartmentNumberInvoice, isFocusedParentView: $isApartmentNumberTextFieldFocused)
                
                CustomTextField(textFieldProperty: "Zip Code", textFieldKeyboardType: .phonePad, textFieldSignsLimit: 6, text: $registerViewModel.zipCodeInvoice, isFocusedParentView: $isZipCodeTextFieldFocused)
                
                CustomTextField(textFieldProperty: "City", textFieldSignsLimit: 20, text: $registerViewModel.cityInvoice, isFocusedParentView: $isCityTextFieldFocused)
                
                HStack {
                    Text("Country: ")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Picker(selection: $registerViewModel.country, label: Text("")) {
                        ForEach(Array(possibleCuntriesDictionary.values), id: \.self) { country in
                            Text(country)
                        }
                    }
                    .labelsHidden()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor, lineWidth: 1))
                    
                    Spacer()
                }
                .padding()
                .padding(.bottom, 20)
            }
            
            Button("Back") {
                withAnimation {
                    presentSecondRegisterView = false
                }
            }
            .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor))
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .contentShape(Rectangle())
            .padding(.bottom, 20)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager: AuthStateManager = AuthStateManager()
        let locationManager: LocationManager = LocationManager()
        let contentViewModel: ContentViewModel = ContentViewModel()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                RegisterView()
                    .environmentObject(authStateManager)
                    .environmentObject(locationManager)
                    .environmentObject(contentViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
