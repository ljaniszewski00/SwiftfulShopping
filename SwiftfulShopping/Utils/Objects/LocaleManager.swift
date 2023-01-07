//
//  LocaleManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/11/2022.
//

import Foundation

class LocaleManager: ObservableObject {
    var clientLanguageCode = Locale.current.languageCode
    var clientCurrencyCode = Locale.current.currencyCode
    
    static var client: LocaleManager = {
        LocaleManager()
    }()
    
    func formatPrice(price: Double) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        return currencyFormatter.string(from: NSNumber(value: price))
    }
    
    // MARK: - -  PRIVATE
    
    private init() {}
}

extension LocaleManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
