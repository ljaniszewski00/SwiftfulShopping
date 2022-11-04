//
//  OrderStatusLocalizable.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/11/2022.
//

import Foundation

public enum OrderStatusLocalizable: String {
    case placed = "OrderStatus_placed"
    case payed = "OrderStatus_payed"
    case picked = "OrderStatus_picked"
    case readyToBeSend = "OrderStatus_readyToBeSend"
    case sent = "OrderStatus_sent"
    case delivered = "OrderStatus_delivered"
    case closed = "OrderStatus_closed"
    case returned = "OrderStatus_returned"
}
