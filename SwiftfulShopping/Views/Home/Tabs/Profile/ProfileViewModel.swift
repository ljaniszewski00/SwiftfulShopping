//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile = Profile.demoProfile
    
    @Published var oldImage = UIImage(named: "blank_profile_image")!
    @Published var image = UIImage(named: "blank_profile_image")!
    
    @Published var shouldPresentOrderRateView: Bool = false
    @Published var shouldPresentReturnCreationView: Bool = false
    
    @Published var shouldPresentSettingsView: Bool = false

    func uploadPhoto() {
        if !image.isEqual(oldImage) {
            oldImage = image
        }
    }

    func changeDefaultAddress(addressDescription: String) {
        for address in profile.shipmentAddresses {
            if address.description == addressDescription {
                profile.defaultShipmentAddress = address
                break
            }
        }
    }
    
    func getAddressFor(addressDescription: String) -> Address? {
        for address in profile.shipmentAddresses {
            if address.description == addressDescription {
                return address
            }
        }
        return nil
    }

    func editPersonalData(fullName: String,
                          emailAddress: String = "") {
        if !fullName.isEmpty {
            profile.fullName = fullName
        }
        if !emailAddress.isEmpty {
            profile.email = emailAddress
        }
    }

    func addNewAddress(address: Address, toBeDefault: Bool = false, completion: @escaping ((VoidResult) -> ())) {
        FirestoreAuthenticationManager.client.createShipmentAddress(shipmentAddress: address) { result in
            completion(result)
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
