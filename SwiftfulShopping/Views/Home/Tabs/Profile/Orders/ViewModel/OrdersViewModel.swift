//
//  OrdersViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class OrdersViewModel: ObservableObject {
    @Published var userOrders: [Order] = []
    @Published var showLoadingModal: Bool = false
    
    var datesForOrdersViewListSections: [String] {
        var ordersShortDates: [String] = []
        for order in userOrders {
            ordersShortDates.append(Date.getMonthNameAndYearFrom(date: order.orderDate))
        }
        return ordersShortDates.uniqued()
            .sorted { $0.suffix(4) > $1.suffix(4) }
    }
    
    func getOrdersFor(date: String) -> [Order] {
        return userOrders
            .filter { Date.getMonthNameAndYearFrom(date: $0.orderDate) == date }
            .sorted { $0.orderDate > $1.orderDate }
    }
    
    func getOrderProductsWithQuantityFor(order: Order) -> [Product: Int] {
        var productsWithQuantity: [Product: Int] = [:]
        if let products = ProductsRepository.shared.products {
            for (productID, quantity) in order.productsIDsWithQuantity {
                if let product = products.filter({ $0.id == productID }).first {
                    productsWithQuantity[product] = quantity
                }
            }
        }
        return productsWithQuantity
    }
    
    func getOrderAllProductsQuantity(order: Order) -> Int {
        getOrderProductsWithQuantityFor(order: order).values.reduce(0, +)
    }
}
