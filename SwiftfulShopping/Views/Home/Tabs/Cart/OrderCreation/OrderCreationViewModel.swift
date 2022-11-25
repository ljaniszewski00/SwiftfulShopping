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
    @Published var shouldPresentStripePaymentSheet: Bool = false
    @Published var shouldPresentOrderCreationCompletionView: Bool = false
    
    @Published var showLoadingModal: Bool = false
    @Published var orderPayed: Bool = false
    @Published var shouldPresentPaymentProcessingModal: Bool = false
    
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
    
    private var paymentMethodForShippingMethod: [ShippingMethod: [PaymentMethod]] = [
        .courier: [.creditCard, .applePay],
        .parcel: [.creditCard, .applePay]
    ]
    
    var shippingPrice: Double? {
        if let currencyCode = LocaleManager.client.clientCurrencyCode,
           let choosenShippingMethod = choosenShippingMethod,
           let shippingMethodPrices = Order.shippingMethodsPrices[choosenShippingMethod],
           let shippingMethodPrice = shippingMethodPrices[currencyCode] {
            return shippingMethodPrice
        }
        return nil
    }
    
    var formattedShippingPrice: String? {
        if let shippingPrice = shippingPrice,
           let formattedShippingMethodPrice = LocaleManager.client.formatPrice(price: shippingPrice) {
            return formattedShippingMethodPrice
        }
        return nil
    }
    
    var paymentPrice: Double? {
        if let currencyCode = LocaleManager.client.clientCurrencyCode,
           let choosenPaymentMethod = choosenPaymentMethod,
           let paymentMethodPrices = Order.paymentMethodPrices[choosenPaymentMethod],
           let paymentMethodPrice = paymentMethodPrices[currencyCode] {
            return paymentMethodPrice
        }
        return nil
    }
        
    var formattedPaymentPrice: String? {
        if let paymentPrice = paymentPrice,
           let formattedPaymentMethodPrice = LocaleManager.client.formatPrice(price: paymentPrice) {
            return formattedPaymentMethodPrice
        }
        return nil
    }
    
    var shippingPaymentPrice: Double? {
        if let shippingPrice = shippingPrice, let paymentPrice = paymentPrice {
            return shippingPrice + paymentPrice
        }
        return nil
    }
    
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
                     productsCost: Double,
                     totalCostWithAppliedDiscounts: Double,
                     shippingAddress: Address,
                     completion: @escaping ((Result<String, Error>) -> ())) {
        let productsIDsWithQuantity = Dictionary(uniqueKeysWithValues: productsWithQuantity.map { key, value in
            (key.id, value)
        })
        
        showLoadingModal = true
        
        guard let currencyCode = LocaleManager.client.clientCurrencyCode else { return }
        
        guard let choosenShippingMethod = choosenShippingMethod,
              let shippingMethodPrices = Order.shippingMethodsPrices[choosenShippingMethod],
              let shippingMethodPrice = shippingMethodPrices[currencyCode] else { return }
        
        guard let choosenPaymentMethod = choosenPaymentMethod,
              let paymentMethodPrices = Order.paymentMethodPrices[choosenPaymentMethod],
              let paymentMethodPrice = paymentMethodPrices[currencyCode] else { return }
        
        let totalCost: Double = totalCostWithAppliedDiscounts + shippingMethodPrice + paymentMethodPrice
        
        var appliedDiscountsCodesWithValues: [String: Double] = [:]
        for appliedDiscount in appliedDiscounts {
            appliedDiscountsCodesWithValues[appliedDiscount.discountCode] = appliedDiscount.discountValuePercent
        }
        
        let order = Order(id: UUID().uuidString,
                          orderDate: Date(),
                          estimatedDeliveryDate: calculateEstimatedDeliveryDate(orderDate: Date(), shippingMethod: choosenShippingMethod),
                          clientID: client.id,
                          clientDescription: client.description,
                          addressDescription: shippingAddress.description,
                          productsIDsWithQuantity: productsIDsWithQuantity,
                          shippingMethod: choosenShippingMethod,
                          shippingAddressID: shippingAddress.id,
                          paymentMethod: choosenPaymentMethod,
                          invoice: toReceiveInvoice,
                          productsCost: productsCost,
                          appliedDiscountsCodesWithValue: appliedDiscountsCodesWithValues,
                          shippingCost: shippingPrice ?? 0,
                          paymentCost: paymentPrice ?? 0,
                          totalCost: totalCost,
                          status: .placed)
        
        FirestoreOrdersManager.createUserOrder(order: order) { [weak self] result in
            switch result {
            case .success:
                self?.createdOrder = order
                FirestoreProductsManager.editProductsSoldUnitsNumber(productsIDsWithQuantity: productsIDsWithQuantity) { _ in
                    FirestoreProductsManager.editProductsQuantityAvailable(productsIDsWithQuantitySold: productsIDsWithQuantity) { _ in
                        if !appliedDiscounts.isEmpty {
                            FirestoreProductsManager.redeemDiscounts(userID: client.id,
                                                                            discounts: appliedDiscounts) { [weak self] in
                                self?.showLoadingModal = false
                                completion(.success(order.id))
                            }
                        } else {
                            self?.showLoadingModal = false
                            completion(.success(order.id))
                        }
                    }
                }
            case .failure(let error):
                self?.showLoadingModal = false
                completion(.failure(error))
            }
        }
    }
    
    func payForOrder(orderID: String, completion: @escaping ((VoidResult) -> ())) {
        //MARK: Mock method for payments handling
//        self.shouldPresentPaymentProcessingModal = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            self?.shouldPresentPaymentProcessingModal = false
//            completion(.success)
//        }
    }
}
