//
//  ReturnStatus.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation
import texterify_ios_sdk

enum ReturnStatus: String {
    case reported
    case sent
    case delivered
    case moneyReturned
    case closed
    
    var rawValue: String {
        switch self {
        case .reported:
            return TexterifyManager.localisedString(key: .returnStatus(.reported))
        case .sent:
            return TexterifyManager.localisedString(key: .returnStatus(.sent))
        case .delivered:
            return TexterifyManager.localisedString(key: .returnStatus(.delivered))
        case .moneyReturned:
            return TexterifyManager.localisedString(key: .returnStatus(.moneyReturned))
        case .closed:
            return TexterifyManager.localisedString(key: .returnStatus(.closed))
        }
    }
    
    var decodeValue: String {
        switch self {
        case .reported:
            return "Reported"
        case .sent:
            return "Sent"
        case .delivered:
            return "Delivered"
        case .moneyReturned:
            return "Money Returned"
        case .closed:
            return "Closed"
        }
    }
}

extension ReturnStatus: CaseIterable {
    static var allCases: [ReturnStatus] {
        return [.reported, .sent, .delivered, .moneyReturned, .closed]
    }
}

extension ReturnStatus {
    static func withLabel(_ label: String) -> ReturnStatus? {
        return self.allCases.first { "\($0.decodeValue)" == label }
    }
}
