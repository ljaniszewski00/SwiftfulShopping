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
        return ordersShortDates.uniqued().sorted { firstDate, secondDate in
            firstDate.suffix(4) > secondDate.suffix(4)
        }
    }
    
    func getOrdersFor(date: String) -> [Order] {
        return userOrders.filter {
            Date.getMonthNameAndYearFrom(date: $0.orderDate) == date
        }
    }
    
    func getOrderProductsFor(order: Order) -> [Product] {
        if let products = ProductsRepository.shared.products {
            return products.filter { order.productsIDs.contains($0.id) }.sorted { $0.name < $1.name }
        } else {
            return []
        }
    }
}
