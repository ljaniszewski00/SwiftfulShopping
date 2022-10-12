//
//  OrderStatus.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import Foundation

enum OrderStatus: String {
    case placed = "Placed"
    case payed = "Payed"
    case picked = "Picked"
    case readyToBeSend = "Ready to be send"
    case sent = "Sent"
    case delivered = "Delivered"
    case closed = "Closed"
    case returned = "Returned"
}

extension OrderStatus: CaseIterable {
    static var allCases: [OrderStatus] {
        return [.placed, .payed, .picked, .readyToBeSend, .sent, .delivered, .closed, .returned]
    }
}

extension OrderStatus {
    static func withLabel(_ label: String) -> OrderStatus? {
        return self.allCases.first { "\($0)" == label }
    }
}
