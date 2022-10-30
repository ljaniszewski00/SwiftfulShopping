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
        return returnsShortDates.uniqued().sorted { firstDate, secondDate in
            firstDate.suffix(4) > secondDate.suffix(4)
        }
    }
    
    func getReturnsFor(date: String) -> [Return] {
        return userReturns.filter {
            Date.getMonthNameAndYearFrom(date: $0.returnDate) == date
        }
    }
    
    func getReturnProductsFor(returnObject: Return) -> [Product] {
        if let products = ProductsRepository.shared.products {
            return products.filter { returnObject.productsIDs.contains($0.id) }.sorted { $0.name < $1.name }
        } else {
            return []
        }
    }
}
