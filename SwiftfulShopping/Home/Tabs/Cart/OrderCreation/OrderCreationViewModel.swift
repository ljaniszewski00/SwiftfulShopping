//
//  OrderCreationViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import Foundation

class OrderCreationViewModel: ObservableObject {
    @Published var choosenShippingMethod: ShippingMethod?
    @Published var choosenAddress: Address?
    @Published var choosenPaymentMethod: PaymentMethod?
    @Published var toReceiveInvoice: Bool = false
    
    @Published var otherAddresses: [Address] = []
    
    @Published var shouldPresentOrderCreationAddressChangeView: Bool = false
    @Published var shouldPresentOrderCreationSummaryView: Bool = false
    @Published var shouldPresentOrderCreationCompletionView: Bool = false
    @Published var shouldPresentCartView: Bool = false
    
    @Published var newStreetName: String = ""
    @Published var newStreetNumber: String = ""
    @Published var newApartmentNumber: String = ""
    @Published var newZipCode: String = ""
    @Published var newCity: String = ""
    @Published var newCountry: String = ""
    @Published var addressToBeSaved: Bool = false
    @Published var addressToBeDefault: Bool = false
    
    @Published var createdOrder: Order?
    
    var newAddressFieldsNotValidated: Bool {
        newStreetName.isEmpty || newStreetNumber.isEmpty || newZipCode.isEmpty || newCity.isEmpty || newCountry.isEmpty
    }
    
    var cannotProceedToSummaryView: Bool {
        choosenShippingMethod == nil || choosenAddress == nil || choosenPaymentMethod == nil
    }
    
    func changeDeliveryAddress(address: Address) {
        otherAddresses.append(choosenAddress!)
        choosenAddress = address
        for (index, addressToBeDeleted) in otherAddresses.enumerated() {
            if addressToBeDeleted == address {
                otherAddresses.remove(at: index)
            }
        }
    }
    
    func createNewAddress() -> Address {
        let newAddress = Address(streetName: newStreetName, streetNumber: newStreetNumber, apartmentNumber: newApartmentNumber, zipCode: newZipCode, city: newCity, country: newCountry)
        otherAddresses.append(choosenAddress!)
        choosenAddress = newAddress
        eraseNewAddressData()
        return newAddress
    }
    
    private func eraseNewAddressData() {
        newStreetName = ""
        newStreetNumber = ""
        newApartmentNumber = ""
        newZipCode = ""
        newCity = ""
        newCountry = ""
        addressToBeSaved = false
        addressToBeDefault = false
    }
    
    func createOrder(client: Profile, shoppingCart: Cart) {
        createdOrder = Order(client: client, shoppingCart: shoppingCart, shippingMethod: choosenShippingMethod!, shippingAddress: choosenAddress!, paymentMethod: choosenPaymentMethod!, invoice: toReceiveInvoice)
    }
}
