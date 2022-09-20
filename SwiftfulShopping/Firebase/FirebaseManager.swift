//
//  FirebaseManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/09/2022.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin

class FirebaseAuthManager: ObservableObject {
    let auth: Auth = Auth.auth()
    
    static var client: FirebaseAuthManager = {
        FirebaseAuthManager()
    }()
    
    private init() {}
    
    
    // MARK: Google SignIn
    
    private func getGoogleSignInCredentials(completion: @escaping ((AuthCredential?, Error?) -> ())) {
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
        getGoogleSignInCredentials { [weak self] credential, error in
            if let credential = credential {
                self?.auth.signIn(with: credential) { (result, error) in
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
    
    
    // MARK: Facebook SignIn
    
    private func getFacebookSignInCredentials(completion: @escaping ((AuthCredential?, Error?) -> ())) {
        LoginManager().logIn(permissions: ["email"],
                             from: nil) { result, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let result = result, let token = result.token {
                    let tokenString = token.tokenString
                    let credential = FacebookAuthProvider.credential(withAccessToken:
                                                                        tokenString)
                    completion(credential, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func firebaseFacebookSignIn(completion: @escaping ((Bool, Error?) -> ())) {
        getFacebookSignInCredentials { [weak self] credential, error in
            if let credential = credential {
                self?.auth.signIn(with: credential) { (result, error) in
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
    
    
    // MARK: GitHub SignIn
    
    private func getGitHubSignInCredentials(completion: @escaping ((AuthCredential?, Error?) -> ())) {
        
    }
    
    func firebaseGitHubSignIn(completion: @escaping ((Bool, Error?) -> ())) {
        getFacebookSignInCredentials { [weak self] credential, error in
            
        }
    }
    
    
    // MARK: Firebase SignOut
    
    func firebaseSignOut() -> (Bool, Error?) {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            return (false, signOutError)
        }
        return (true, nil)
    }
}

extension FirebaseAuthManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
