//
//  FirebaseManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/09/2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

class FirebaseAuthManager: ObservableObject {
    static var client: FirebaseAuthManager = {
        FirebaseAuthManager()
    }()
    
    private init() {}
    
    func googleSignInCredentials(completion: @escaping ((AuthCredential?, Error?) -> ())) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: EmptyView().getRootViewController()) { user, error in
                    
            if let error = error {
              completion(nil, error)
            }
                    
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return completion(nil, error)
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)

            // Use the credential to authenticate with Firebase
            completion(credential, nil)
        }
    }
    
    func firebaseGoogleSignIn(completion: @escaping ((Bool, Error?) -> ())) {
        googleSignInCredentials { credential, error in
            if let credential = credential {
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error {
                        completion(false, error)
                    }
                    completion(true, nil)
                }
            } else {
                completion(false, error)
            }
        }
    }
}

extension FirebaseAuthManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
