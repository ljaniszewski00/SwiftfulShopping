//
//  ReturnsViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class ReturnsViewModel: ObservableObject {
    @Published var userReturns: [Return] = []
    @Published var showLoadingModal: Bool = false
    
    var datesForReturnsViewListSections: [String] {
        var returnsShortDates: [String] = []
        for userReturn in userReturns {
            returnsShortDates.append(Date.getMonthNameAndYearFrom(date: userReturn.returnDate))
        }
        return returnsShortDates.uniqued()
            .sorted { $0.suffix(4) > $1.suffix(4) }
    }
    
    func getReturnsFor(date: String) -> [Return] {
        return userReturns
            .filter { Date.getMonthNameAndYearFrom(date: $0.returnDate) == date }
            .sorted { $0.returnDate > $1.returnDate }
    }
    
    func getReturnProductsWithQuantityFor(userReturn: Return) -> [Product: Int] {
        var productsWithQuantity: [Product: Int] = [:]
        if let products = ProductsRepository.shared.products {
            for (productID, quantity) in userReturn.productsIDsWithQuantity {
                if let product = products.filter({ $0.id == productID }).first {
                    productsWithQuantity[product] = quantity
                }
            }
        }
        return productsWithQuantity
    }
    
    func getReturnAllProductsQuantity(userReturn: Return) -> Int {
        getReturnProductsWithQuantityFor(userReturn: userReturn).values.reduce(0, +)
    }
}
