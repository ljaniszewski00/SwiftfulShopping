import StripePaymentSheet
import SwiftUI

class StripeViewModel: ObservableObject {
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var paymentData: [String: String]?
    
    @Published var showLoadingModal: Bool = false
    
    var canPresentOrderPaymentView: Bool {
        paymentSheet != nil
    }
    
    func prepareFirebaseForPayment(profileID: String, amount: Double, currency: String, completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        
        FirestoreStripeManager.createStripeCheckoutSession(profileID: profileID,
                                                           amount: handleAmountForCurrency(amount: amount, currency: currency),
                                                           currency: currency) { result in
            switch result {
            case .success(let checkoutSessionDocumentID):
                FirestoreStripeManager.listenToStripeCheckoutSession(profileID: profileID, checkoutSessionDocumentID: checkoutSessionDocumentID) { [weak self] result in
                    self?.showLoadingModal = false
                    switch result {
                    case .success(let paymentData):
                        guard let paymentData = paymentData else { return }
                        self?.paymentData = paymentData
                        completion(.success)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func preparePaymentSheet() {
        guard let paymentData = paymentData,
              let paymentIntentClientSecret = paymentData["paymentIntentClientSecret"],
              let ephemeralKeySecret = paymentData["ephemeralKeySecret"],
              let customer = paymentData["customer"] else { return }
        
        guard let stripeAPIKey = StripeConstants.stripeAPIKey else { return }
        STPAPIClient.shared.publishableKey = stripeAPIKey
        
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.style = .automatic
        configuration.merchantDisplayName = "SwiftfulShopping"
        configuration.customer = .init(id: customer, ephemeralKeySecret: ephemeralKeySecret)
        configuration.allowsDelayedPaymentMethods = true
        
        let paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        
        DispatchQueue.main.async {
            self.paymentSheet = paymentSheet
        }
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
    
    func updateOrderDataAfterSuccessfulPayment(profileID: String, orderID: String, currency: String, completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        
        FirestoreProfileManager.getNewestPaymentIDFor(profileID: profileID) { [weak self] result in
            switch result {
            case .success(let paymentID):
                guard let paymentID = paymentID else {
                    self?.showLoadingModal = false
                    return
                }
                
                let updateData: [String: Any] = [
                    "currency": currency,
                    "payed": true,
                    "paymentID": paymentID
                ]
                
                FirestoreOrdersManager.updateOrderDataAfterSuccessfulPayment(orderID: orderID, updateData: updateData) { result in
                    self?.showLoadingModal = false
                    completion(result)
                }
            case .failure(let error):
                self?.showLoadingModal = false
                completion(.failure(error))
            }
        }
    }
    
    private func handleAmountForCurrency(amount: Double, currency: String) -> Int {
        // MARK: Amount for currency handling for Stripe transaction according to: https://stripe.com/docs/currencies#zero-decimal
        // Transaction amount in Stripe should be given in integer so if user has to pay 100.99 the amount of transaction should be set to 10099 (multiplied by 100).
        
        let currenciesForStripeWithoutMultiplication: [String] = [
            // These are currencies that do not need multiplication and these are:
            "BIF", "CLP", "DJF", "GNF", "JPY", "KMF", "KRW", "MGA", "PYG", "RWF", "UGX", "VND", "VUV", "XAF", "XOF", "XPF"
        ]
        
        let currenciesWithSpecialHandling: [String] = [
            // There are currencies that require special handling and these are:
            "HUF", "TWD"
        ]
        
        if currenciesForStripeWithoutMultiplication.contains(where: { $0.lowercased() == currency.lowercased() }) {
            return Int(amount)
        } else if currenciesWithSpecialHandling.contains(where: { $0.lowercased() == currency.lowercased() }) {
            return Int(amount) * 100
        } else {
            return Int(amount * 100)
        }
    }
}
