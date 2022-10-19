//
//  ReturnCreationViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import Foundation

class ReturnCreationViewModel: ObservableObject {
    @Published var productsForReturn: [Product] = []
    
    @Published var bankAccountNumber: String = ""
    @Published var nameOfBankAccountOwner: String = ""
    @Published var streetAndHouseNumber: String = ""
    @Published var postalCode: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    
    @Published var shippingMethod: ShippingMethod = .parcel
    
    @Published var shouldPresentSecondReturnCreationView: Bool = false
    @Published var shouldPresentThirdReturnCreationView: Bool = false
    @Published var shouldPresentCompletionReturnCreationView: Bool = false
    
    @Published var orderForReturn: Order?
    @Published var createdReturn: Return?
    
    var fieldsNotValidated: Bool {
        bankAccountNumber.isEmpty || nameOfBankAccountOwner.isEmpty || streetAndHouseNumber.isEmpty || postalCode.isEmpty || city.isEmpty || country.isEmpty
    }
    
    func manageProductToReturn(product: Product) {
        if productsForReturn.contains(product) {
            for (index, productForReturn) in productsForReturn.enumerated() {
                if productForReturn == product {
                    productsForReturn.remove(at: index)
                }
            }
        } else {
            productsForReturn.append(product)
        }
    }
    
    func createReturn(clientID: String, orderID: String) {
        var returnPrice: Double = 0
        for productsForReturn in productsForReturn {
            returnPrice += productsForReturn.price
        }
        
        let newestCreatedReturn = Return(clientID: clientID,
                                         orderID: orderID,
                                         productsIDs: productsForReturn.map { $0.id },
                                         returnPrice: returnPrice,
                                         returnMethod: shippingMethod,
                                         bankAccountNumber: bankAccountNumber,
                                         bankAccountOwnerName: nameOfBankAccountOwner,
                                         bankAccountOwnerStreetAndHouseNumber: streetAndHouseNumber,
                                         bankAccountOwnerPostalCode: postalCode,
                                         bankAccountOwnerCity: city,
                                         bankAccountOwnerCountry: country)
        
        createdReturn = newestCreatedReturn
    }
}
