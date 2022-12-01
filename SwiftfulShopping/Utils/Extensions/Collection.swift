//
//  Collection.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/12/2022.
//

import Foundation

extension Collection {

    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}
