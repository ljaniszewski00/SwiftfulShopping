import StripePaymentSheet
import SwiftUI

class StripeViewModel: ObservableObject {
    private var backendCheckoutURL: URL? = URL(string: StripeConstants.stripeBackendCheckoutURL ?? "")
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        guard let backendCheckoutURL = backendCheckoutURL else { return }
        
        var request = URLRequest(url: backendCheckoutURL)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        print("Here \(request)")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let self = self else {
                // Handle error
                print("Here Error \(error?.localizedDescription)")
                return
            }
            
            guard let stripeAPIKey = StripeConstants.stripeAPIKey else { return }
            STPAPIClient.shared.publishableKey = stripeAPIKey
            
            print("Here Got Key")
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.style = .automatic
            configuration.merchantDisplayName = "SwiftfulShopping"
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment methods
            // that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = true
            
            DispatchQueue.main.async {
                print("Here Adding Sheet")
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
}
