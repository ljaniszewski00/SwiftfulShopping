//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var userOrders: [Order] = []
    @Published var userReturns: [Return] = []
    
    @Published var oldImage: UIImage = UIImage(named: AssetsNames.blankProfile)!
    @Published var image: UIImage = UIImage(named: AssetsNames.blankProfile)!
    
    @Published var shouldPresentOrderRateView: Bool = false
    @Published var shouldPresentReturnCreationView: Bool = false
    
    @Published var shouldPresentSettingsView: Bool = false
    
    @Published var showLoadingModal = false
    
    func fetchData(completion: @escaping ((VoidResult) -> ())) {
        fetchProfile { [weak self] result in
            switch result {
            case .success:
                self?.fetchUserOrders {
                    self?.fetchUserReturns {
                        completion(.success)
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProfile(completion: @escaping ((VoidResult) -> ())) {
        if let user = FirebaseAuthManager.client.user {
            FirestoreProfileManager.client.getUserProfile(userID: user.uid) { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    self?.fetchCreditCard()
                    if let profileImageURL = profile?.imageURL {
                        if !profileImageURL.isEmpty {
                            FirebaseStorageManager.client.downloadImageFromStorage(userID: user.uid,
                                                                                   imageURL: profileImageURL) { [weak self] result in
                                switch result {
                                case .success(let image):
                                    if let image = image {
                                        self?.oldImage = image
                                        self?.image = image
                                    }
                                case .failure(_):
                                    break
                                }
                            }
                        }
                    }
                    
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCreditCard() {
        if let creditCardNumber = UserDefaults.standard.value(forKey: UserDefaultsKeys.creditCardNumber.rawValue) as? String,
           let creditCardValidThru = UserDefaults.standard.value(forKey: UserDefaultsKeys.creditCardValidThru.rawValue) as? String,
           let creditCardHolderName = UserDefaults.standard.value(forKey: UserDefaultsKeys.creditCardHolderName.rawValue) as? String {
            let creditCard = CreditCard(cardNumber: creditCardNumber,
                                        validThru: creditCardValidThru,
                                        cardholderName: creditCardHolderName)
            self.profile?.creditCard = creditCard
        }
    }
    
    func fetchUserOrders(completion: @escaping (() -> ())) {
        if let user = FirebaseAuthManager.client.user {
            OrdersRepository.shared.fetchUserOrders(userID: user.uid) { [weak self] orders in
                self?.userOrders = orders ?? []
                completion()
            }
        }
    }
    
    func fetchUserReturns(completion: @escaping (() -> ())) {
        if let user = FirebaseAuthManager.client.user {
            ReturnsRepository.shared.fetchUserReturns(userID: user.uid) { [weak self] returns in
                self?.userReturns = returns ?? []
                completion()
            }
        }
    }

    func changePhoto(completion: @escaping ((VoidResult) -> ())) {
        if image.isEqual(oldImage) {
            completion(.success)
        } else {
            if let profile = self.profile {
                if let profileImageURL = profile.imageURL {
                    if !profileImageURL.isEmpty {
                        FirebaseStorageManager.client.deleteImageFromStorage(userID: profile.id,
                                                                             imageURL: profileImageURL) { _ in }
                    }
                    FirebaseStorageManager.client.uploadImageToStorage(image: self.image,
                                                                       userID: profile.id) { [weak self] result in
                        switch result {
                        case .success(let imageUUID):
                            if let imageUUID = imageUUID {
                                FirestoreProfileManager.client.updateProfileImageURL(profileID: profile.id,
                                                                                     imageURL: imageUUID) { result in
                                    switch result {
                                    case .success:
                                        self?.oldImage = self!.image
                                        self?.profile?.imageURL = imageUUID
                                        completion(.success)
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
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

    func editCardData(cardNumber: String, validThru: String, cardHolderName: String) {
        UserDefaults.standard.set(cardNumber, forKey: UserDefaultsKeys.creditCardNumber.rawValue)
        UserDefaults.standard.set(validThru, forKey: UserDefaultsKeys.creditCardValidThru.rawValue)
        UserDefaults.standard.set(cardHolderName, forKey: UserDefaultsKeys.creditCardHolderName.rawValue)
        
        fetchCreditCard()
    }

    func changeDefaultPaymentMethod(newDefaultPaymentMethod: PaymentMethod, completion: @escaping ((VoidResult) -> ())) {
        if let profile = profile {
            FirestoreProfileManager.client.changeDefaultPaymentMethod(userID: profile.id,
                                                                      newDefaultPaymentMethod: newDefaultPaymentMethod.decodeValue) { result in
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
