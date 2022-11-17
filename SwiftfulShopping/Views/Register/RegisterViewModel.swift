//
//  RegisterViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import Foundation
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    @Published var usersAndEmailsListener: ListenerRegistration?
    @Published var usersUsernames: [String]?
    @Published var usersEmails: [String]?
    
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
    
    func onFirstRegisterViewAppear() {
        FirestoreAuthenticationManager.listenToUsersUsernamesAndEmails { result in
            switch result {
            case .success(let (usersUsernames, usersEmails)):
                self.usersUsernames = usersUsernames
                self.usersEmails = usersEmails
            case .failure(_):
               print("Error fetching usernames and emails for duplicates checking")
            }
        }
    }
    
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
    
    var usernameTaken: Bool {
        if let usersUsernames = usersUsernames {
            return usersUsernames.contains(username)
        } else {
            return false
        }
    }
    
    var isUsernameValid: Bool {
        if username.isEmpty {
            return true
        } else {
            return username.count >= 5
        }
    }
    
    var emailTaken: Bool {
        if let usersEmails = usersEmails {
            return usersEmails.contains(email)
        } else {
            return false
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
        !usernameTaken &&
        !email.isEmpty &&
        isEmailValid &&
        !emailTaken &&
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
    
    func completeRegistration(completion: @escaping ((VoidResult) -> ())) {
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
                        if let fullName = self?.fullName,
                           let username = self?.username,
                           let birthDate = self?.birthDate,
                           let email = self?.email {
                            
                            let profile = Profile(id: user.uid,
                                                  fullName: fullName,
                                                  username: username,
                                                  birthDate: birthDate,
                                                  email: email,
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
