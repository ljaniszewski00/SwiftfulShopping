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
    
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1900, month: 1, day: 1)
        let endComponents = DateComponents(year: calendar.dateComponents([.year], from: calendar.date(byAdding: .year, value: -18, to: Date()) ?? Date()).year, month: calendar.dateComponents([.month], from: calendar.date(byAdding: .year, value: -18, to: Date()) ?? Date()).month, day: calendar.dateComponents([.day], from: calendar.date(byAdding: .year, value: -18, to: Date()) ?? Date()).day)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 1.3)
                    .position(x: ScreenBoundsSupplier.shared.getScreenWidth() * 0.515, y: ScreenBoundsSupplier.shared.getScreenHeight() * 0.1)
                
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
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9)
                        .contentShape(Rectangle())
                        .padding(.bottom, 20)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.95)
                            .foregroundColor(.white)
                    }
                    .padding(.top, presentSecondRegisterView ? 20 : 100)
                }
                .padding()
            }
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
            Text("Please provide personal data:")
                .font(.callout)
                .foregroundColor(.gray)
                .bold()
                .padding(.vertical)
            
            CustomTextField(textFieldProperty: "First Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.firstName, isFocusedParentView: $isFirstNameTextFieldFocused)
            
            CustomTextField(textFieldProperty: "Last Name", textFieldImageName: "person", textFieldSignsLimit: 0, text: $registerViewModel.lastName, isFocusedParentView: $isLastNameTextFieldFocused)
            
            CustomTextField(textFieldProperty: "Username", textFieldImageName: "person", textFieldSignsLimit: 20, text: $registerViewModel.username, isFocusedParentView: $isUsernameTextFieldFocused)
            
            HStack {
                DatePicker(selection: $registerViewModel.birthDate, in: dateRange, displayedComponents: .date, label: {
                    Text("Birth Date:")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                })
                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5)
                Spacer()
            }
            .padding(.horizontal)
            
            CustomTextField(textFieldProperty: "E-mail", textFieldImageName: "envelope", textFieldSignsLimit: 0, text: $registerViewModel.email, isFocusedParentView: $isEmailTextFieldFocused)
            
            HStack {
                CustomTextField(isSecureField: true, textFieldProperty: "Password", textFieldImageName: "lock", text: $registerViewModel.password, isFocusedParentView: $isPasswordTextFieldFocused)
                
                Image(systemName: "questionmark.circle")
                    .foregroundColor(dataError ? .red : showPasswordHint ? .accentColor : .gray)
                    .onTapGesture {
                        withAnimation {
                            showPasswordHint.toggle()
                        }
                    }
                    .padding(.trailing)
            }
            
            if showPasswordHint {
                Text("Password should be at least 8 characters long and should contain a number.")
                    .font(.callout)
                    .foregroundColor(dataError ? .red : .gray)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
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
            .buttonStyle(CustomButton(buttonWidthMultiplier: 0.8, imageName: "paperplane"))
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
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                RegisterView()
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
