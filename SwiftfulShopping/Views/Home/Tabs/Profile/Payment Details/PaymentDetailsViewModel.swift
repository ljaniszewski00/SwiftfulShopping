//
//  PaymentDetailsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import Foundation

class PaymentDetailsViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var cardHolderName: String = ""
    @Published var newDate: Date = Date()
    
    @Published var editingCardData: Bool = false
    @Published var showLoadingModal: Bool = false
    
    var validThruDate: String {
        var dateString: String = ""
        
        let dateMonth = newDate.get(.month)
        let dateYear = newDate.get(.year)
        
        if dateMonth < 10 {
            dateString += "0\(String(dateMonth))"
        } else {
            dateString += String(dateMonth)
        }
        
        dateString += "/"
        dateString += String(dateYear)
        return dateString
    }
    
    var cardCompany: CardCompany {
        for (cardCompany, regex) in creditCardCompaniesVerificationRegexes {
            if let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) {
                let match = regex.firstMatch(in: cardNumber, range: NSMakeRange(0, cardNumber.count))
                if match != nil { return cardCompany }
            }
        }
        
        return .other
    }
    
    var cardCompanyImageName: String? {
        switch cardCompany {
        case .americanExpress:
            return AssetsNames.creditCardAmericanExpress
        case .visa:
            return AssetsNames.creditCardVisaWhite
        case .mastercard:
            return AssetsNames.creditCardMastercard
        case .discover:
            return AssetsNames.creditCardDiscover
        case .other:
            return nil
        }
    }
    
    var newCardInfoNotValidated: Bool {
        cardNumber.isEmpty ||
        !cardNumberLengthValid ||
        !luhnCheck() ||
        validThruDate.isEmpty ||
        !validThruCheck() ||
        cardHolderName.isEmpty
    }
    
    func initializeDataForNoCard() {
        cardNumber = "XXXXXXXXXXXXXXXX"
        cardHolderName = "John Smith"
    }
    
    // MARK: - PRIVATE
    
    private var creditCardCompaniesVerificationRegexes: [CardCompany: String] = [
        .americanExpress: "^3[47][0-9]{5,}$",
        .visa: "^4[0-9]{6,}([0-9]{3})?$",
        .mastercard: "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$",
        .discover: "^6(?:011|5[0-9]{2})[0-9]{3,}$"
    ]
    
    private var cardNumberLengthValid: Bool {
        switch cardCompany {
        case .americanExpress:
            return cardNumber.count == 15
        default:
            return cardNumber.count == 16
        }
    }
    
    private func validThruCheck() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let enteredDate = dateFormatter.date(from: newDate.dateString())!
        let endOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: enteredDate)!
        let now = Date()
        if (endOfMonth < now) {
            return false
        } else {
            return true
        }
    }
    
    private func luhnCheck() -> Bool {
        var sum = 0
        let digitStrings = cardNumber.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            guard let digit = Int(tuple.element) else { return false }
            let odd = tuple.offset % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
}
