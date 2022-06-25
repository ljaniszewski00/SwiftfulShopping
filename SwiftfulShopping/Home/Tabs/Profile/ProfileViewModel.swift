//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile = Profile.demoProfile
    @Published var orders: [Order] = Order.demoOrders
    @Published var returns: [Return] = Return.demoReturns
    
    var datesForOrdersViewListSections: [String] {
        var ordersShortDates: [String] = []
        for order in orders {
            ordersShortDates.append(Date.getMonthNameAndYearFrom(date: order.orderDate))
        }
        return ordersShortDates.uniqued().sorted { firstDate, secondDate in
            firstDate.suffix(4) > secondDate.suffix(4)
        }
    }
    
    func getOrdersFor(date: String) -> [Order] {
        return orders.filter {
            Date.getMonthNameAndYearFrom(date: $0.orderDate) == date
        }
    }
}
