//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile = Profile.demoProfile
    @Published var orders: [Order] = Order.demoOrders
    @Published var returns: [Return] = Return.demoReturns
    
    @Published var oldImage = UIImage(named: "blank_profile_image")!
    @Published var image = UIImage(named: "blank_profile_image")!
    
    @Published var shouldPresentOrderRateView: Bool = false
    @Published var shouldPresentReturnCreationView: Bool = false
    
    var datesForOrdersViewListSections: [String] {
        var ordersShortDates: [String] = []
        for order in orders {
            ordersShortDates.append(Date.getMonthNameAndYearFrom(date: order.orderDate))
        }
        return ordersShortDates.uniqued().sorted { firstDate, secondDate in
            firstDate.suffix(4) > secondDate.suffix(4)
        }
    }
    
    var datesForReturnsViewListSections: [String] {
        var returnsShortDates: [String] = []
        for userReturn in returns {
            returnsShortDates.append(Date.getMonthNameAndYearFrom(date: userReturn.returnDate))
        }
        return returnsShortDates.uniqued().sorted { firstDate, secondDate in
            firstDate.suffix(4) > secondDate.suffix(4)
        }
    }

    func uploadPhoto() {
        if !image.isEqual(oldImage) {
            oldImage = image
        }
    }
    
    func getOrdersFor(date: String) -> [Order] {
        return orders.filter {
            Date.getMonthNameAndYearFrom(date: $0.orderDate) == date
        }
    }
    
    func getReturnsFor(date: String) -> [Return] {
        return returns.filter {
            Date.getMonthNameAndYearFrom(date: $0.returnDate) == date
        }
    }
    
    func changeDefaultAddress(address: Address) {
        removeAddress(address: address)
        profile.otherAddresses.append(profile.address)
        profile.address = address
    }
    
    func removeAddress(address: Address) {
        for (index, otherAddress) in profile.otherAddresses.enumerated() {
            if otherAddress == address {
                profile.otherAddresses.remove(at: index)
                break
            }
        }
    }
    
    func editPersonalData(firstName: String = "", lastName: String = "", emailAddress: String = "") {
        if !firstName.isEmpty {
            profile.firstName = firstName
        }
        if !firstName.isEmpty {
            profile.firstName = firstName
        }
        if !firstName.isEmpty {
            profile.firstName = firstName
        }
    }
    
    func addNewAddress(address: Address, toBeDefault: Bool = false) {
        if toBeDefault {
            profile.otherAddresses.append(profile.address)
            profile.address = address
        } else {
            profile.otherAddresses.append(address)
        }
    }
    
    func editCardData(cardNumber: String, validThru: String, cardholderName: String) {
        if profile.creditCard != nil {
            profile.creditCard!.cardNumber = cardNumber
            profile.creditCard!.validThru = validThru
            profile.creditCard!.cardholderName = cardholderName
        }
    }
    
    func addNewCard(card: CreditCard) {
        profile.creditCard = card
    }
    
    func changeDefaultPaymentMethod(newDefaultPaymentMethod: PaymentMethod) {
        profile.defaultPaymentMethod = newDefaultPaymentMethod
    }
    
    func addUserRating(productID: String, rating: Int, review: String?) {
        profile.addRatingFor(productID: productID, rating: rating, review: review)
    }
}
