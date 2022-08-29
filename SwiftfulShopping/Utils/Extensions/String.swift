//
//  String.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/08/2022.
//

import Foundation

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
