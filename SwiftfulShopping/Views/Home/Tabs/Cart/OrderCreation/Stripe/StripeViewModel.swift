import StripePaymentSheet
import SwiftUI

class StripeViewModel: ObservableObject {
    private var backendCheckoutURL: URL? = URL(string: StripeConstants.stripeBackendCheckoutURL ?? "")
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentSheetCreated: Bool = false
    @Published var paymentResult: PaymentSheetResult?
    @Published var paymentData: [String: Any]?
    
    func prepareFirebaseForPayment(profileID: String, amount: Double, currency: String, completion: @escaping ((VoidResult) -> ())) {
        FirestoreStripeManager.createStripeCheckoutSession(profileID: profileID, amount: amount, currency: currency) { result in
            switch result {
            case .success(let checkoutSessionDocumentID):
                FirestoreStripeManager.listenToStripeCheckoutSession(profileID: profileID, checkoutSessionDocumentID: checkoutSessionDocumentID) { [weak self] result in
                    switch result {
                    case .success(let paymentData):
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
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        guard let backendCheckoutURL = backendCheckoutURL else { return }
        
//        var request = URLRequest(url: backendCheckoutURL)
//        request.httpMethod = "POST"
//        request.setValue("application/json",
//                         forHTTPHeaderField: "Content-Type")
//        print("Here \(request)")
//
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
//            print(data)
//            print()
//            print(response)
//            print()
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//                  let customerId = json["customer"] as? String,
//                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
//                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
//                  let self = self else {
//                // Handle error
//                print("Here Error \(error?.localizedDescription)")
//                return
//            }
//
//
//        })
//        task.resume()
        guard let paymentData = paymentData,
              let paymentIntentClientSecret = paymentData["paymentIntentClientSecret"] as? String,
              let ephemeralKeySecret = paymentData["ephemeralKeySecret"] as? String,
              let customer = paymentData["customer"] as? String else { return }
        
        guard let stripeAPIKey = StripeConstants.stripeAPIKey else { return }
        STPAPIClient.shared.publishableKey = stripeAPIKey
        
        print("Here Got Key")
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.style = .automatic
        configuration.merchantDisplayName = "SwiftfulShopping"
        configuration.customer = .init(id: customer, ephemeralKeySecret: ephemeralKeySecret)
        // Set `allowsDelayedPaymentMethods` to true if your business can handle payment methods
        // that complete payment after a delay, like SEPA Debit and Sofort.
        configuration.allowsDelayedPaymentMethods = true
        
        DispatchQueue.main.async {
            print("Here Adding Sheet")
            self.paymentSheetCreated = true
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        }
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
}
