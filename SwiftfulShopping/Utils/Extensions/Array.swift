//
//  Array.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/06/2022.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
