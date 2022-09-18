//
//  OrderCreationViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import Foundation

class OrderCreationViewModel: ObservableObject {
    @Published var choosenShippingMethod: ShippingMethod?
    @Published var choosenPaymentMethod: PaymentMethod?
    @Published var toReceiveInvoice: Bool = false
    
    @Published var defaultAddress: String = ""
    @Published var addresses: [String: String?] = [:]
    
    @Published var shouldPresentOrderCreationAddressChangeView: Bool = false
    @Published var shouldPresentOrderCreationSummaryView: Bool = false
    @Published var shouldPresentOrderCreationCompletionView: Bool = false
    
    @Published var newStreetName: String = ""
    @Published var newStreetNumber: String = ""
    @Published var newApartmentNumber: String = ""
    @Published var newZipCode: String = ""
    @Published var newCity: String = ""
    @Published var newCountry: String = ""
    @Published var addressToBeSaved: Bool = false
    @Published var addressToBeDefault: Bool = false
    
    @Published var discountCode: String = ""
    
    @Published var createdOrder: Order?
    
    var newAddressFieldsNotValidated: Bool {
        newStreetName.isEmpty || newStreetNumber.isEmpty || newZipCode.isEmpty || newCity.isEmpty || newCountry.isEmpty
    }
    
    var cannotProceedToSummaryView: Bool {
        choosenShippingMethod == nil || defaultAddress.isEmpty || choosenPaymentMethod == nil
    }
    
    func setupAddresses(defaultProfileAddress: Address,
                        profileAddresses: [Address]) {
        defaultAddress = defaultProfileAddress.description
        for profileAddress in profileAddresses {
            addresses.updateValue(nil,
                                  forKey: profileAddress.description)
        }
    }
    
    func createNewAddress() -> Address {
        let newAddress = Address(streetName: newStreetName, streetNumber: newStreetNumber, apartmentNumber: newApartmentNumber, zipCode: newZipCode, city: newCity, country: newCountry)
        eraseNewAddressData()
        return newAddress
    }
    
    private func eraseNewAddressData() {
        newStreetName.removeAll()
        newStreetNumber.removeAll()
        newApartmentNumber.removeAll()
        newZipCode.removeAll()
        newCity.removeAll()
        newCountry.removeAll()
        addressToBeSaved = false
        addressToBeDefault = false
    }
    
    func applyDiscount() -> Discount? {
        discountCode.removeAll()
        
        /*
         SOME DATABASE CHECKING IF DISCOUNT CODE IS LEGIBLE:
        
         var fetchedDiscount = fetchDiscountData(self.discountCode)
         */
        
        return Discount.demoDiscounts[0]
    }
    
    func createOrder(client: Profile,
                     shoppingCart: Cart,
                     shippingAddress: Address) {
        createdOrder = Order(client: client,
                             shoppingCart: shoppingCart,
                             shippingMethod: choosenShippingMethod!,
                             shippingAddress: shippingAddress,
                             paymentMethod: choosenPaymentMethod!,
                             invoice: toReceiveInvoice)
    }
}
