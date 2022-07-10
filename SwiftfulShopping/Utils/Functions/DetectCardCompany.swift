//
//  DetectCardCompany.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/07/2022.
//

import Foundation

func detectCardCompany(cardNumber: String) -> CardCompany {
    switch cardNumber.first {
    case "3":
        return .americanExpress
    case "4":
        return .visa
    case "5":
        return .mastercard
    case "6":
        return .discover
    default:
        return .other
    }
}
