//
//  RegisterViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import Foundation


class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var birthDate: Date = Date()
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var streetName: String = ""
    @Published var streetNumber: String = ""
    @Published var apartmentNumber: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    
    var addressDataGiven: Bool {
        !streetName.isEmpty && !streetNumber.isEmpty && !apartmentNumber.isEmpty && !zipCode.isEmpty && !city.isEmpty && !country.isEmpty
    }
    
    @Published var sameDataOnInvoice: Bool = true
    
    @Published var firstNameInvoice: String = ""
    @Published var lastNameInvoice: String = ""
    @Published var streetNameInvoice: String = ""
    @Published var streetNumberInvoice: String = ""
    @Published var apartmentNumberInvoice: String = ""
    @Published var zipCodeInvoice: String = ""
    @Published var cityInvoice: String = ""
    @Published var countryInvoice: String = ""
    
    /// To be removed
    func fillPersonalData() {
        self.firstName = "Jan"
        self.lastName = "Kowalski"
        self.username = "jan.kowalski"
        self.email = "email@email.to"
        self.password = "Haslo123"
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
            
            if let country = addressData["country"] {
                self.country = country
            }
        }
    }
    
    func checkEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func checkPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func checkStreetNumber(_ streetNumber: String) -> Bool {
        CharacterSet(charactersIn: streetNumber).isSubset(of: CharacterSet.decimalDigits)
    }
    
    func checkApartmentNumber(_ apartmentNumber: String) -> Bool {
        CharacterSet(charactersIn: apartmentNumber).isSubset(of: CharacterSet.decimalDigits)
    }
    
    func checkPersonalDataFieldsEmpty() -> Bool {
        return firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty
    }
    
    func checkAddressDataFieldsEmpty() -> Bool {
        return streetName.isEmpty || streetNumber.isEmpty || apartmentNumber.isEmpty || zipCode.isEmpty || city.isEmpty || country.isEmpty
    }
    
    func checkInvoiceDataFieldsEmpty() -> Bool {
        return streetNameInvoice.isEmpty || streetNumberInvoice.isEmpty || apartmentNumberInvoice.isEmpty || zipCodeInvoice.isEmpty || cityInvoice.isEmpty || countryInvoice.isEmpty
    }
    
    func checkZipCode(_ zipCode: String) -> Bool {
        var zipCodeWithoutDash = ""
        for character in zipCode {
            if character == "-" {
                continue
            } else {
                zipCodeWithoutDash.append(character)
            }
        }
        if country != "United States" {
            return CharacterSet(charactersIn: zipCodeWithoutDash).isSubset(of: CharacterSet.decimalDigits) && zipCode.contains("-")
        } else {
            return CharacterSet(charactersIn: zipCodeWithoutDash).isSubset(of: CharacterSet.decimalDigits)
        }
    }
    
    func completeFirstRegistrationStep() -> (Bool, String) {
        var error = false
        var message = ""
        
        if !checkEmail(email) {
            error = true
            message.append("Please, check your e-mail.\n")
        }
        
        if !checkPassword(password) {
            error = true
            message.append("Please, check your password.\n")
        }
        
        if checkPersonalDataFieldsEmpty() {
            error = true
            message.append("Please, check if you have provided all the data.\n")
        }
        
        if error {
            return (false, message)
        }
        
        return (true, message)
    }
    
    func completeSecondRegistrationStep() -> (Bool, String) {
        
        var error = false
        var message = ""
        
        if addressDataGiven {
            if !checkStreetNumber(streetNumber) {
                error = true
                message.append("Please, check your street number.\n")
            }
            
            if !checkApartmentNumber(apartmentNumber) {
                error = true
                message.append("Please, check your apartment number.\n")
            }
            
            if !checkZipCode(zipCode) {
                error = true
                message.append("Please, check your zip code.\n")
            }
            
            if checkAddressDataFieldsEmpty() {
                error = true
                message.append("Please, check if you have provided all the data.\n")
            }
            
            if error {
                return (false, message)
            }
            
            if sameDataOnInvoice {
                self.firstNameInvoice = firstName
                self.lastNameInvoice = lastName
                self.streetNameInvoice = streetName
                self.streetNumberInvoice = streetNumber
                self.apartmentNumberInvoice = apartmentNumber
                self.zipCodeInvoice = zipCode
                self.cityInvoice = city
                self.countryInvoice = country
                
                return (true, message)
            } else {
                if !checkStreetNumber(streetNumberInvoice) {
                    error = true
                    message.append("Please, check your invoice street number.\n")
                }
                
                if !checkApartmentNumber(apartmentNumberInvoice) {
                    error = true
                    message.append("Please, check your invoice apartment number.\n")
                }
                
                if !checkZipCode(zipCodeInvoice) {
                    error = true
                    message.append("Please, check your invoice zip code.\n")
                }
                
                if checkInvoiceDataFieldsEmpty() {
                    error = true
                    message.append("Please, check if you have provided all the data.\n")
                }
                
                if error {
                    return (false, message)
                }
                
                return (true, message)
            }
        } else {
            return (true, message)
        }
    }
    
    func completeRegistration() {
        
    }
}
