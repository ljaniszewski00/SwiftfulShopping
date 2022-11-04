//
//  PersonalInfoViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/07/2022.
//

import Foundation

class PersonalInfoViewModel: ObservableObject {
    @Published var defaultAddress: String = ""
    @Published var addresses: [String: String?] = [:]
    
    @Published var newFullName: String = ""
    @Published var newEmailAddress: String = ""
    
    @Published var newStreetName: String = ""
    @Published var newStreetNumber: String = ""
    @Published var newApartmentNumber: String = ""
    @Published var newZipCode: String = ""
    @Published var newCity: String = ""
    @Published var newCountry: String = ""
    @Published var toBeDefaultAddress: Bool = false
    
    @Published var showLoadingModal: Bool = false
    
    let countries: [String: String?] = ["Czech": "czech",
                                        "England": "england",
                                        "France": "france",
                                        "Germany": "germany",
                                        "Poland": "poland",
                                        "Spain": "spain",
                                        "United States": "united"]
    
    func setupAddresses(defaultProfileAddress: Address, profileAddresses: [Address]) {
        defaultAddress = defaultProfileAddress.description
        for profileAddress in profileAddresses {
            addresses.updateValue(nil,
                                  forKey: profileAddress.description)
        }
    }
    
    var newPersonalInfoFieldsNotValidated: Bool {
        let components = newFullName.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count < 2 || newEmailAddress.isEmpty
    }
    
    var newAddressFieldsNotValidated: Bool {
        newStreetName.isEmpty || newStreetNumber.isEmpty || newZipCode.isEmpty || newCity.isEmpty || newCountry.isEmpty
    }
    
    func createNewAddress() -> Address? {
        guard let user = FirebaseAuthManager.client.user else {
            return nil
        }
        
        return Address(userID: user.uid, fullName: newFullName, streetName: newStreetName, streetNumber: newStreetNumber, apartmentNumber: newApartmentNumber, zipCode: newZipCode, city: newCity, country: newCountry)
    }
}
