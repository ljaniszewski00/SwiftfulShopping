//
//  getIndexesOfOccurencesOfSubstringInString.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 16/11/2022.
//

import Foundation

func getIndexesOfOcurrencesOf(_ substring: String, in searchString: String) -> [String.Index] {
    var searchRange = searchString.startIndex..<searchString.endIndex
    var indices: [String.Index] = []

    while let range = searchString.range(of: substring,
                                         options: .caseInsensitive,
                                         range: searchRange) {
        searchRange = range.upperBound..<searchRange.upperBound
        indices.append(range.lowerBound)
    }
    
    return indices
}
