//
//  CustomError.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import Foundation

struct CustomError {
    var errorType: ErrorType
    var errorCode: Int
    var errorDescription: String = ""
}
