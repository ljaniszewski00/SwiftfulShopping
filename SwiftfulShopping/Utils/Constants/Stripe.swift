//
//  Stripe.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/11/2022.
//

import Foundation

struct StripeConstants {
    static let stripeAPIKey: String? = Bundle.main.infoDictionary?["StripeAPIKey"] as? String
    static let stripeBackendCheckoutURL: String? = Bundle.main.infoDictionary?["StripeBackendCheckoutURL"] as? String
}
