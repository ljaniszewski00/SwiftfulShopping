//
//  FirstTimeLoginViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/09/2022.
//

import Foundation

class FirstTimeLoginViewModel: ObservableObject {
    @Published var streetName: String = ""
    @Published var streetNumber: String = ""
    @Published var apartmentNumber: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = Countries.poland.rawValue
    
    @Published var sameDataOnInvoice: Bool = true
    
    @Published var firstNameInvoice: String = ""
    @Published var lastNameInvoice: String = ""
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
    
    var isInvoiceFirstNameValid: Bool {
        isLettersOnlyFieldValid(text: firstNameInvoice)
    }
    
    var isInvoiceLastNameValid: Bool {
        isLettersOnlyFieldValid(text: lastNameInvoice)
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
    
    var addressDataGiven: Bool {
        !streetName.isEmpty && !streetNumber.isEmpty && !zipCode.isEmpty && !city.isEmpty && !country.isEmpty
    }
    
    var invoiceDataGiven: Bool {
        !streetNameInvoice.isEmpty && !streetNumberInvoice.isEmpty && !zipCodeInvoice.isEmpty && !cityInvoice.isEmpty && !countryInvoice.isEmpty
    }
    
    var canCompleteLogin: Bool {
        if sameDataOnInvoice {
            return addressDataGiven
        } else {
            return addressDataGiven && invoiceDataGiven
        }
    }
}
