//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile = Profile(firstName: "Jan",
                                              lastName: "Kowalski",
                                              username: "jan.kowalski",
                                              birthDate: Date(),
                                              email: "jan.kowalski@email.com",
                                              address: Address(streetName: "Wierzbowskiego",
                                                               streetNumber: "13",
                                                               apartmentNumber: "26",
                                                               zipCode: "23-123",
                                                               city: "New York",
                                                               country: "United"),
                                              imageURL: "dd")
    
}
