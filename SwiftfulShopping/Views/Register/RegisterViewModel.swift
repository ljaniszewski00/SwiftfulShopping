//
//  RegisterViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import Foundation


class RegisterViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var username: String = ""
    @Published var birthDate: Date = Date()
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var fullNameShipment: String = ""
    @Published var streetName: String = ""
    @Published var streetNumber: String = ""
    @Published var apartmentNumber: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = Countries.poland.rawValue
    
    @Published var sameDataOnInvoice: Bool = true
    
    @Published var fullNameInvoice: String = ""
    @Published var streetNameInvoice: String = ""
    @Published var streetNumberInvoice: String = ""
    @Published var apartmentNumberInvoice: String = ""
    @Published var zipCodeInvoice: String = ""
    @Published var cityInvoice: String = ""
    @Published var countryInvoice: String = Countries.poland.rawValue
    
    @Published var presentSecondRegisterView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    let countries: [String: String?] = ["Czech": "czech",
                                        "England": "england",
                                        "France": "france",
                                        "Germany": "germany",
                                        "Poland": "poland",
                                        "Spain": "spain",
                                        "United States": "united"]
    
    func getAddressDataFromLocation(addressData: [String: String]) {
        if !addressData.isEmpty {
            if let streetName = addressData["streetName"] {
                self.streetName = streetName
            }
            
            if let streetNumber = addressData["streetNumber"] {
                self.streetNumber = streetNumber
            }
            
            if let zipCode = addressData["zipCode"] {
                self.zipCode = zipCode
            }
            
            if let city = addressData["city"] {
                self.city = city
            }
        }
    }
    
    // MARK: Generic methods to validate letters and numeric fields
    
    private func isFullNameValid(text: String) -> Bool {
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count >= 2
    }
    
    private func isEmailValid(text: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: text)
    }
    
    private func isPasswordValid(text: String) -> Bool {
        // One big letter, one number and at least 8 characters
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordRegex)
        return passwordPredicate.evaluate(with: text)
    }
    
    private func isLettersOnlyFieldValid(text: String) -> Bool {
        let numbersRange = text.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (numbersRange != nil)
        return !hasNumbers
    }
    
    private func isNumericOnlyFieldValid(text: String) -> Bool {
        CharacterSet(charactersIn: text).isSubset(of: CharacterSet.decimalDigits)
    }
    
    private func isZipCodeFieldValid(text: String) -> Bool {
        if text.isEmpty {
            return true
        } else {
            return (CharacterSet(charactersIn: text).isSubset(of: CharacterSet.decimalDigits) && text.count == 5)
        }
    }
    
    
    // MARK: Validating FirstRegisterView
    
    var isFullNameValid: Bool {
        if fullName.isEmpty {
            return true
        } else {
            return isLettersOnlyFieldValid(text: fullName) && isFullNameValid(text: fullName)
        }
    }
    
    var isUsernameValid: Bool {
        if username.isEmpty {
            return true
        } else {
            return username.count >= 5
        }
    }
    
    var isEmailValid: Bool {
        if email.isEmpty {
            return true
        } else {
            return isEmailValid(text: email)
        }
    }
    
    var isPasswordValid: Bool {
        if password.isEmpty {
            return true
        } else {
            return isPasswordValid(text: password)
        }
    }
    
    // MARK: Validating Shipment Address fields
    
    var isFullNameShipmentValid: Bool {
        if fullNameShipment.isEmpty {
            return true
        } else {
            return isLettersOnlyFieldValid(text: fullNameShipment) && isFullNameValid(text: fullNameShipment)
        }
    }
    
    var isStreetNameValid: Bool {
        isLettersOnlyFieldValid(text: streetName)
    }
    
    var isStreetNumberValid: Bool {
        isNumericOnlyFieldValid(text: streetNumber)
    }
    
    var isApartmentNumberValid: Bool {
        isNumericOnlyFieldValid(text: apartmentNumber)
    }
    
    var isZipCodeValid: Bool {
        isZipCodeFieldValid(text: zipCode)
    }
    
    var isCityNameValid: Bool {
        isLettersOnlyFieldValid(text: city)
    }
    
    
    // MARK: Validating Invoice fields
    
    var isInvoiceFullNameValid: Bool {
        if fullNameInvoice.isEmpty {
            return true
        } else {
            return isLettersOnlyFieldValid(text: fullNameInvoice) && isFullNameValid(text: fullNameInvoice)
        }
    }
    
    var isInvoiceStreetNameValid: Bool {
        isLettersOnlyFieldValid(text: streetNameInvoice)
    }
    
    var isInvoiceStreetNumberValid: Bool {
        isNumericOnlyFieldValid(text: streetNumberInvoice)
    }
    
    var isInvoiceApartmentNumberValid: Bool {
        isNumericOnlyFieldValid(text: apartmentNumberInvoice)
    }
    
    var isInvoiceZipCodeValid: Bool {
        isZipCodeFieldValid(text: zipCodeInvoice)
    }
    
    var isInvoiceCityNameValid: Bool {
        isLettersOnlyFieldValid(text: cityInvoice)
    }
    
    
    // MARK: Final validation of each section
    
    var personalDataValid: Bool {
        !fullName.isEmpty &&
        isFullNameValid &&
        !username.isEmpty &&
        isUsernameValid &&
        !email.isEmpty &&
        isEmailValid &&
        !password.isEmpty &&
        isPasswordValid
    }
    
    var addressDataValid: Bool {
        !fullNameShipment.isEmpty &&
        isFullNameShipmentValid &&
        !streetName.isEmpty &&
        isStreetNameValid &&
        !streetNumber.isEmpty &&
        isStreetNumberValid &&
        !zipCode.isEmpty &&
        isZipCodeValid &&
        !city.isEmpty &&
        isCityNameValid &&
        !country.isEmpty
    }
    
    var invoiceDataValid: Bool {
        !fullNameInvoice.isEmpty &&
        isFullNameValid &&
        !streetNameInvoice.isEmpty &&
        isInvoiceStreetNameValid &&
        !streetNumberInvoice.isEmpty &&
        isInvoiceStreetNumberValid &&
        !zipCodeInvoice.isEmpty &&
        isInvoiceZipCodeValid &&
        !cityInvoice.isEmpty &&
        isInvoiceCityNameValid &&
        !countryInvoice.isEmpty
    }
    
    var canCompleteFirstRegistrationStep: Bool {
        personalDataValid
    }
    
    var canCompleteSecondRegistrationStep: Bool {
        if sameDataOnInvoice {
            return addressDataValid
        } else {
            return addressDataValid && invoiceDataValid
        }
    }
    
    var canCompleteRegistration: Bool {
        canCompleteFirstRegistrationStep && canCompleteSecondRegistrationStep
    }
    
    func fillInvoiceData() {
        if sameDataOnInvoice {
            fullNameInvoice = fullNameShipment
            streetNameInvoice = streetName
            streetNumberInvoice = streetNumber
            zipCodeInvoice = zipCode
            cityInvoice = city
            countryInvoice = country
        }
    }
    
    func completeFirstRegisterStep() {
        fullNameShipment = fullName
        presentSecondRegisterView = true
    }
    
    func completeSecondRegisterStep() {
        if sameDataOnInvoice {
            fillInvoiceData()
        }
    }
    
    func completeRegistration(completion: @escaping ((Bool, Error?) -> ())) {
        let shipmentAddress = Address(fullName: fullName,
                                      streetName: streetName,
                                      streetNumber: streetNumber,
                                      apartmentNumber: apartmentNumber,
                                      zipCode: zipCode,
                                      city: city,
                                      country: country)
        FirestoreManager.client.createShipmentAddress(shipmentAddress: shipmentAddress) { [weak self] success, error in
            if let error = error {
                completion(false, error)
            } else {
                let invoiceAddress: Address?
                if self!.sameDataOnInvoice {
                    invoiceAddress = shipmentAddress
                } else {
                    invoiceAddress = Address(fullName: self!.fullNameInvoice,
                                             streetName: self!.streetNameInvoice,
                                             streetNumber: self!.streetNumberInvoice,
                                             apartmentNumber: self!.apartmentNumberInvoice,
                                             zipCode: self!.zipCodeInvoice,
                                             city: self!.cityInvoice,
                                             country: self!.countryInvoice)
                }
                
                FirestoreManager.client.createInvoiceAddress(invoiceAddress: invoiceAddress!) { [weak self] success, error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        let profile = Profile(fullName: self!.fullName,
                                              username: self!.username,
                                              birthDate: self!.birthDate,
                                              email: self!.email,
                                              defaultShipmentAddress: shipmentAddress,
                                              invoiceAddress: invoiceAddress!)
                        FirestoreManager.client.createProfile(profile: profile) { success, error in
                            if let error = error {
                                completion(false, error)
                            } else {
                                completion(true, nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
