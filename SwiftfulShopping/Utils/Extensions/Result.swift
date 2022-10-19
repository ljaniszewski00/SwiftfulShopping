//
//  Result.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/10/2022.
//

import Foundation

public extension Result where Success == Void {
    
    /// A success, storing a Success value.
    ///
    /// Instead of `.success`, now  `.success`
    static var success: Result {
        return .success
    }
}
