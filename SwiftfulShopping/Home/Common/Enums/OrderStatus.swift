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
