//
//  LoginViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var showLoadingModal: Bool = false
    
    @Published var choosenSignInMethod: SignInMethod = .emailPassword
    
    @Published var showFirstTimeLoginView: Bool = false
    
    // FirstTimeLogin
    @Published var streetName: String = ""
    @Published var streetNumber: String = ""
    @Published var apartmentNumber: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = Countries.poland.rawValue
    
    var addressDataGiven: Bool {
        !streetName.isEmpty && !streetNumber.isEmpty && !zipCode.isEmpty && !city.isEmpty && !country.isEmpty
    }
    
    @Published var sameDataOnInvoice: Bool = true
    
    @Published var firstNameInvoice: String = ""
    @Published var lastNameInvoice: String = ""
    @Published var streetNameInvoice: String = ""
    @Published var streetNumberInvoice: String = ""
    @Published var apartmentNumberInvoice: String = ""
    @Published var zipCodeInvoice: String = ""
    @Published var cityInvoice: String = ""
    @Published var countryInvoice: String = Countries.poland.rawValue
    
    func verifyAccount() {
        
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
    
    func checkZipCode(_ zipCode: String) -> Bool {
        if let dashIndex = zipCode.firstIndex(of: "-") {
            var tempZipCode = zipCode
            tempZipCode.remove(at: dashIndex)
            return CharacterSet(charactersIn: tempZipCode).isSubset(of: CharacterSet.decimalDigits)
        } else {
            return CharacterSet(charactersIn: zipCode).isSubset(of: CharacterSet.decimalDigits)
        }
    }
    
    func checkAddressDataFieldsEmpty() -> Bool {
        return streetName.isEmpty || streetNumber.isEmpty || apartmentNumber.isEmpty || zipCode.isEmpty || city.isEmpty || country.isEmpty
    }
    
    func checkInvoiceDataFieldsEmpty() -> Bool {
        return streetNameInvoice.isEmpty || streetNumberInvoice.isEmpty || apartmentNumberInvoice.isEmpty || zipCodeInvoice.isEmpty || cityInvoice.isEmpty || countryInvoice.isEmpty
    }
    
    func completeAddressProviding() -> (Bool, String) {
        
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
}
