//
//  FirstTimeLoginViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/09/2022.
//

import Foundation
import texterify_ios_sdk

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
    
    @Published var showLoadingModal: Bool = false
    
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
    
    
    // MARK: - Generic methods to validate letters and numeric fields
    
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
    
    // MARK: - Validating Shipment Address fields
    
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
    
    
    // MARK: - Validating Invoice fields
    
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
    
    
    // MARK: - Final validation of each section
    
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
    
    func completeFirstTimeLogin(completion: @escaping ((VoidResult) -> ())) {
        guard let user = FirebaseAuthManager.client.user else {
            return
        }
        
        let shipmentAddress = Address(userID: user.uid,
                                      fullName: fullName,
                                      streetName: streetName,
                                      streetNumber: streetNumber,
                                      apartmentNumber: apartmentNumber,
                                      zipCode: zipCode,
                                      city: city,
                                      country: country,
                                      isDefaultAddress: true)
        FirestoreAuthenticationManager.createShipmentAddress(shipmentAddress: shipmentAddress) { [weak self] result in
            switch result {
            case .success:
                let invoiceAddress: Address?
                if self!.sameDataOnInvoice {
                    invoiceAddress = shipmentAddress
                } else {
                    if let fullNameInvoice = self?.fullNameInvoice,
                       let streetNameInvoice = self?.streetNameInvoice,
                       let streetNumberInvoice = self?.streetNumberInvoice,
                       let apartmentNumberInvoice = self?.apartmentNumberInvoice,
                       let zipCodeInvoice = self?.zipCodeInvoice,
                       let cityInvoice = self?.cityInvoice,
                       let countryInvoice = self?.countryInvoice {
                        
                        invoiceAddress = Address(userID: user.uid,
                                                 fullName: fullNameInvoice,
                                                 streetName: streetNameInvoice,
                                                 streetNumber: streetNumberInvoice,
                                                 apartmentNumber: apartmentNumberInvoice,
                                                 zipCode: zipCodeInvoice,
                                                 city: cityInvoice,
                                                 country: countryInvoice,
                                                 isDefaultAddress: true)
                    } else {
                        invoiceAddress = shipmentAddress
                    }
                }
                
                FirestoreAuthenticationManager.createInvoiceAddress(invoiceAddress: invoiceAddress!) { [weak self] result in
                    switch result {
                    case .success:
                        let profile = Profile(id: user.uid,
                                              fullName: self!.fullName,
                                              email: user.email,
                                              defaultShipmentAddress: shipmentAddress,
                                              invoiceAddress: invoiceAddress!,
                                              createdWith: FirebaseAuthManager.client.loggedWith)
                        FirestoreAuthenticationManager.createProfile(profile: profile) { result in
                            switch result {
                            case .success:
                                completion(.success)
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
