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
    
    func createNewAddress() -> Address? {
        if let user = FirebaseAuthManager.client.user {
            let newAddress = Address(userID: user.uid, fullName: "", streetName: newStreetName, streetNumber: newStreetNumber, apartmentNumber: newApartmentNumber, zipCode: newZipCode, city: newCity, country: newCountry)
            eraseNewAddressData()
            return newAddress
        } else {
            return nil
        }
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
    
    func applyDiscount() {
        discountCode.removeAll()
    }
    
    func createOrder(client: Profile,
                     productsWithQuantity: [Product: Int],
                     appliedDiscounts: [Discount],
                     totalCost: Double,
                     totalCostWithAppliedDiscounts: Double,
                     shippingAddress: Address,
                     completion: @escaping ((VoidResult) -> ())) {
        let productsIDsWithQuantity = Dictionary(uniqueKeysWithValues: productsWithQuantity.map { key, value in
            (key.id, value)
        })
        
        let cart = Cart(clientID: client.id,
                        orderID: UUID().uuidString,
                        cartName: "Default",
                        productsIDsWithQuantity: productsIDsWithQuantity,
                        appliedDiscountsIDs: appliedDiscounts.map { $0.id },
                        totalCost: totalCost,
                        totalCostWithAppliedDiscounts: totalCostWithAppliedDiscounts)
        
        let order = Order(id: cart.orderID,
                          orderDate: Date(),
                          estimatedDeliveryDate: calculateEstimatedDeliveryDate(orderDate: Date()),
                          clientID: client.id,
                          clientDescription: client.description,
                          addressDescription: shippingAddress.description,
                          shoppingCartID: cart.id,
                          productsIDs: productsWithQuantity.keys.map { $0.id },
                          shippingMethod: choosenShippingMethod ?? .pickup,
                          shippingAddressID: shippingAddress.id,
                          paymentMethod: choosenPaymentMethod ?? .applePay,
                          invoice: toReceiveInvoice,
                          totalCost: totalCostWithAppliedDiscounts,
                          status: .placed)
        
        FirestoreOrdersManager.client.createUserOrder(order: order) { [weak self] result in
            switch result {
            case .success:
                self?.createdOrder = order
                
                if !appliedDiscounts.isEmpty {
                    FirestoreProductsManager.client.redeemDiscounts(userID: client.id,
                                                                    discounts: appliedDiscounts) {
                        completion(.success)
                    }
                } else {
                    completion(.success)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
