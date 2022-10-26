//
//  ProfileRepository.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 20/10/2022.
//

import Foundation

class ProfileRepository: ObservableObject {
    @Published var profile: Profile?
    
    static var shared: ProfileRepository = {
        ProfileRepository()
    }()
    
    private init() {
        if let userID = FirebaseAuthManager.client.user?.uid {
            fetchProfile(userID: userID) { [weak self] profile in
                self?.profile = profile
            }
        }
    }
    
    func fetchProfile(userID: String, completion: @escaping ((Profile?) -> ())) {
        FirestoreProfileManager.client.getUserProfile(userID: userID) { result in
            switch result {
            case .success(let profile):
                completion(profile)
            case .failure(let error):
                print("Error fetching ratings from repository: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

extension ProfileRepository: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}