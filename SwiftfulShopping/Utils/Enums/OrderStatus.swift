//
//  OrderStatus.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import Foundation
import texterify_ios_sdk

enum OrderStatus: String {
    case placed
    case payed
    case picked
    case readyToBeSend
    case sent
    case delivered
    case closed
    case returned
    
    var rawValue: String {
        switch self {
        case .placed:
            return TexterifyManager.localisedString(key: .orderStatus(.placed))
        case .payed:
            return TexterifyManager.localisedString(key: .orderStatus(.payed))
        case .picked:
            return TexterifyManager.localisedString(key: .orderStatus(.picked))
        case .readyToBeSend:
            return TexterifyManager.localisedString(key: .orderStatus(.readyToBeSend))
        case .sent:
            return TexterifyManager.localisedString(key: .orderStatus(.sent))
        case .delivered:
            return TexterifyManager.localisedString(key: .orderStatus(.delivered))
        case .closed:
            return TexterifyManager.localisedString(key: .orderStatus(.closed))
        case .returned:
            return TexterifyManager.localisedString(key: .orderStatus(.returned))
        }
    }
}

extension OrderStatus: CaseIterable {
    static var allCases: [OrderStatus] {
        return [.placed, .payed, .picked, .readyToBeSend, .sent, .delivered, .closed, .returned]
    }
}

extension OrderStatus {
    static func withLabel(_ label: String) -> OrderStatus? {
        return self.allCases.first { "\($0.rawValue)" == label }
    }
}
