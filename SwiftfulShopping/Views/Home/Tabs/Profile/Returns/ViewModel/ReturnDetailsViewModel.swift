//
//  ReturnDetailsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 13/11/2022.
//

import Foundation

class ReturnDetailsViewModel: ObservableObject {
    @Published var userReturn: Return?
    
    var returnProductsWithQuantity: [Product: Int]? {
        if let userReturn = userReturn {
            var productsWithQuantity: [Product: Int] = [:]
            if let products = ProductsRepository.shared.products {
                for (productID, quantity) in userReturn.productsIDsWithQuantity {
                    if let product = products.filter({ $0.id == productID }).first {
                        productsWithQuantity[product] = quantity
                    }
                }
            }
            return productsWithQuantity
        } else {
            return nil
        }
    }

    var returnAllProductsQuantity: Int? {
        returnProductsWithQuantity?.values.reduce(0, +)
    }
}
