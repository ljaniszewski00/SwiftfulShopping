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

extension String {
    func separate(every stride: Int, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1] }.joined())
    }
}
