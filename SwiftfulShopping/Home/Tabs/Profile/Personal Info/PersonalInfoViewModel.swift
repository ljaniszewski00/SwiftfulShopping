//
//  PersonalInfoViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/07/2022.
//

import Foundation

class PersonalInfoViewModel: ObservableObject {
    @Published var newFirstName: String = ""
    @Published var newLastName: String = ""
    @Published var newEmailAddress: String = ""
    
    @Published var newStreetName: String = ""
    @Published var newStreetNumber: String = ""
    @Published var newApartmentNumber: String = ""
    @Published var newZipCode: String = ""
    @Published var newCity: String = ""
    @Published var newCountry: String = ""
    @Published var toBeDefaultAddress: Bool = false
    
    var newPersonalInfoFieldsNotValidated: Bool {
        newFirstName.isEmpty || newLastName.isEmpty || newEmailAddress.isEmpty
    }
    
    var newAddressFieldsNotValidated: Bool {
        newStreetName.isEmpty || newStreetNumber.isEmpty || newZipCode.isEmpty || newCity.isEmpty || newCountry.isEmpty
    }
    
    func createNewAddress() -> Address {
        Address(streetName: newStreetName, streetNumber: newStreetNumber, apartmentNumber: newApartmentNumber, zipCode: newZipCode, city: newCity, country: newCountry)
    }
}
