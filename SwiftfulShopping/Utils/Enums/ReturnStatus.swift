//
//  ReturnStatus.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation

enum ReturnStatus: String {
    case reported = "Reported"
    case sent = "Sent"
    case delivered = "Delivered"
    case moneyReturned = "Money returned"
    case closed = "Closed"
}

extension ReturnStatus: CaseIterable {
    static var allCases: [ReturnStatus] {
        return [.reported, .sent, .delivered, .moneyReturned, .closed]
    }
}

extension ReturnStatus {
    static func withLabel(_ label: String) -> ReturnStatus? {
        return self.allCases.first { "\($0.rawValue)" == label }
    }
}
