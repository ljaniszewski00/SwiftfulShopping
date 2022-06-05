//
//  PossibleCountries.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

enum PossibleCountries: String {
    case poland
    case unitedStates
}

private(set) var possibleCuntriesDictionary: [PossibleCountries: String] = [.poland: "Poland", .unitedStates: "United States"]
