//
//  ReturnCreationViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import Foundation

class ReturnCreationViewModel: ObservableObject {
    @Published var productsForReturn: [Product: Int] = [:]
    
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
    @Published var productsFromOrder: [Product] = []
    @Published var createdReturn: Return?
    
    var fieldsNotValidated: Bool {
        bankAccountNumber.isEmpty || nameOfBankAccountOwner.isEmpty || streetAndHouseNumber.isEmpty || postalCode.isEmpty || city.isEmpty || country.isEmpty
    }
    
    var returnPrice: Double {
        var returnPrice: Double = 0
        for (product, quantity) in productsForReturn {
            if let price = product.price {
                returnPrice += price * Double(quantity)
            }
        }
        return returnPrice
    }
    
    func getProductsForReturn() {
        if let products = ProductsRepository.shared.products, let orderForReturn = orderForReturn {
            self.productsFromOrder = products.filter { Array(orderForReturn.productsIDsWithQuantity.keys).contains($0.id) }
        }
    }
    
    func manageProductToReturn(product: Product) {
        if productsForReturn.keys.contains(product) {
            _ = productsForReturn.removeValue(forKey: product)
        } else {
            productsForReturn[product] = 1
        }
    }
    
    func increaseProductToReturnQuantity(product: Product) {
        if productsForReturn[product] != nil {
            productsForReturn[product]! += 1
        }
    }
    
    func decreaseProductToReturnQuantity(product: Product) {
        if productsForReturn[product] != nil {
            if productsForReturn[product] == 1 {
                manageProductToReturn(product: product)
            } else {
                productsForReturn[product]! -= 1
            }
        }
    }
    
    func createReturn(clientID: String,
                      orderID: String,
                      completion: @escaping ((VoidResult) -> ())) {
        
        let productsIDsWithQuantity: [String: Int] = Dictionary(uniqueKeysWithValues: productsForReturn.map { (key, value) in (key.id, value)})
        
        let createdReturn = Return(clientID: clientID,
                                         orderID: orderID,
                                         productsIDsWithQuantity: productsIDsWithQuantity,
                                         returnPrice: returnPrice,
                                         returnMethod: shippingMethod,
                                         bankAccountNumber: bankAccountNumber,
                                         bankAccountOwnerName: nameOfBankAccountOwner,
                                         bankAccountOwnerStreetAndHouseNumber: streetAndHouseNumber,
                                         bankAccountOwnerPostalCode: postalCode,
                                         bankAccountOwnerCity: city,
                                         bankAccountOwnerCountry: country)
        
        FirestoreReturnsManager.client.createUserReturn(returnObject: createdReturn) { result in
            switch result {
            case .success:
                self.createdReturn = createdReturn
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
