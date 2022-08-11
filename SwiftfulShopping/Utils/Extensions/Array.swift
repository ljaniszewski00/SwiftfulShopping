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

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Array {
    func split() -> (leftHalf: [Element], rightHalf: [Element]) {
        let arrayElementsCount = self.count
        let halfIndex = (arrayElementsCount / 2)
        if arrayElementsCount % 2 == 0 {
            let leftSplit = self[0 ..< halfIndex]
            let rightSplit = self[halfIndex ..< arrayElementsCount]
            return (leftHalf: Array(leftSplit), rightHalf: Array(rightSplit))
        } else {
            let leftSplit = self[0 ... halfIndex]
            let rightSplit = self[(halfIndex + 1) ..< arrayElementsCount]
            return (leftHalf: Array(leftSplit), rightHalf: Array(rightSplit))
        }
    }
}
