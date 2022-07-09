//
//  PersonalInfoViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/07/2022.
//

import Foundation

class PersonalInfoViewModel: ObservableObject {
    @Published var bankAccountNumber: String = ""
    @Published var nameOfBankAccountOwner: String = ""
    @Published var streetAndHouseNumber: String = ""
    @Published var postalCode: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
}
