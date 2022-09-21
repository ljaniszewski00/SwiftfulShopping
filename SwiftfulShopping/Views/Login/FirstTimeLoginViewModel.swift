//
//  FirstTimeLoginViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/09/2022.
//

import Foundation

class FirstTimeLoginViewModel: ObservableObject {
    @Published var fullName: String = ""
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
    
    // MARK: Validating Shipment Address fields
    
    var isFullNameValid: Bool {
        if fullName.isEmpty {
            return true
        } else {
            return isLettersOnlyFieldValid(text: fullName) && isFullNameValid(text: fullName)
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
    
    var addressDataValid: Bool {
        !fullName.isEmpty &&
        isFullNameValid &&
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
    
    var canCompleteLogin: Bool {
        if sameDataOnInvoice {
            return addressDataValid
        } else {
            return addressDataValid && invoiceDataValid
        }
    }
    
    func fillInvoiceData() {
        if sameDataOnInvoice {
            fullNameInvoice = fullName
            streetNameInvoice = streetName
            streetNumberInvoice = streetNumber
            zipCodeInvoice = zipCode
            cityInvoice = city
            countryInvoice = country
        }
    }
}
