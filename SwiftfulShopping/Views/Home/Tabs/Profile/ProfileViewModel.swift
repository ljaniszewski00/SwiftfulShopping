//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    
    @Published var oldImage = UIImage(named: "blank_profile_image")!
    @Published var image = UIImage(named: "blank_profile_image")!
    
    @Published var shouldPresentOrderRateView: Bool = false
    @Published var shouldPresentReturnCreationView: Bool = false
    
    @Published var shouldPresentSettingsView: Bool = false
    
    @Published var showLoadingModal = false
    
    func fetchProfile(completion: @escaping ((VoidResult) -> ())) {
        if let user = FirebaseAuthManager.client.user {
            FirestoreProfileManager.client.getUserProfile(userID: user.uid) { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func uploadPhoto() {
        if !image.isEqual(oldImage) {
            oldImage = image
        }
    }

    func changeDefaultAddress(addressDescription: String, completion: @escaping ((VoidResult) -> ())) {
        if let profile = profile {
            for address in profile.shipmentAddresses {
                if address.description == addressDescription {
                    FirestoreProfileManager.client.makeAddressDefaultShippingAddress(userID: profile.id,
                                                                                     shipmentAddressToBeMadeDefaultAddress: address) { result in
                        completion(result)
                    }
                }
            }
        }
    }
    
    func getAddressFor(addressDescription: String) -> Address? {
        if let profile = profile {
            for address in profile.shipmentAddresses {
                if address.description == addressDescription {
                    return address
                }
            }
        }
        
        return nil
    }

    func editPersonalData(fullName: String,
                          emailAddress: String = "",
                          completion: @escaping ((VoidResult) -> ())) {
        if let profile = profile {
            let profileDataToUpdate: [String: Any] = [
                "fullName": fullName,
                "email": emailAddress
            ]
            
            FirestoreProfileManager.client.updateProfileData(profileID: profile.id,
                                                             profileDataToUpdate: profileDataToUpdate) { result in
                completion(result)
            }
        }
    }

    func addNewAddress(address: Address, toBeDefault: Bool = false, completion: @escaping ((VoidResult) -> ())) {
        FirestoreAuthenticationManager.client.createShipmentAddress(shipmentAddress: address) { result in
            completion(result)
        }
    }

    func editCardData(cardNumber: String, validThru: String, cardholderName: String) {
        if profile != nil {
            if profile!.creditCard != nil {
                profile!.creditCard!.cardNumber = cardNumber
                profile!.creditCard!.validThru = validThru
                profile!.creditCard!.cardholderName = cardholderName
            }
        }
    }

    func addNewCard(card: CreditCard) {
        if profile != nil {
            profile!.creditCard = card
        }
    }

    func changeDefaultPaymentMethod(newDefaultPaymentMethod: PaymentMethod, completion: @escaping ((VoidResult) -> ())) {
        if let profile = profile {
            FirestoreProfileManager.client.changeDefaultPaymentMethod(userID: profile.id,
                                                                      newDefaultPaymentMethod: newDefaultPaymentMethod.rawValue) { result in
                completion(result)
            }
        }
    }

    func addUserRating(productID: String, rating: Int, review: String?, completion: @escaping ((VoidResult) -> ())) {
        if let profile = profile {
            let productRating = ProductRating(id: UUID().uuidString,
                                              productID: productID,
                                              authorID: profile.id,
                                              authorFirstName: profile.fullName,
                                              rating: rating,
                                              review: review)
            
            FirestoreProductsManager.client.addProductRating(productRating: productRating) { result in
                completion(result)
            }
        }
    }
    
    func signOut(completion: @escaping ((VoidResult) -> ())) {
        showLoadingModal = true
        FirebaseAuthManager.client.firebaseSignOut() { [weak self] result in
            self?.showLoadingModal = false
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
