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
    
    func createReturn(clientID: String, orderID: String) -> Return {
        var returnPrice: Double = 0
        for productsForReturn in productsForReturn {
            returnPrice += productsForReturn.price
        }
        
        return Return(clientID: clientID, orderID: orderID, products: productsForReturn, returnPrice: returnPrice, returnMethod: shippingMethod, bankAccountNumber: bankAccountNumber, bankAccountOwnerName: nameOfBankAccountOwner, bankAccountOwnerStreetAndHouseNumber: streetAndHouseNumber, bankAccountOwnerPostalCode: postalCode, bankAccountOwnerCity: city, bankAccountOwnerCountry: country)
    }
}
