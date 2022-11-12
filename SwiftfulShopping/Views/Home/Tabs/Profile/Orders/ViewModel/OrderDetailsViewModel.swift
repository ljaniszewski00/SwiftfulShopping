//
//  OrderDetailsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/11/2022.
//

import Foundation

class OrderDetailsViewModel: ObservableObject {
    @Published var order: Order?
    @Published var showLoadingModal: Bool = false
    
    var orderProductsWithQuantity: [Product: Int]? {
        if let order = order {
            var productsWithQuantity: [Product: Int] = [:]
            if let products = ProductsRepository.shared.products {
                for (productID, quantity) in order.productsIDsWithQuantity {
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
    
    var orderAllProductsQuantity: Int? {
        orderProductsWithQuantity?.values.reduce(0, +)
    }
}
