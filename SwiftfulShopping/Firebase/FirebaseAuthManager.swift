//
//  FirebaseAuthManager.swift
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
    let gitHubProvider = OAuthProvider(providerID: "github.com")
    
    @Published var user: User?
    @Published var loggedWith: SignInMethod?
    
    static var client: FirebaseAuthManager = {
        FirebaseAuthManager()
    }()
    
    private init() {
        gitHubProvider.customParameters = [
            "allow_signup": "false"
        ]
    }
    
    
    func firebaseSignUp(email: String,
                        password: String,
                        completion: @escaping ((Bool, Error?) -> ())) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                if let authResult = authResult {
                    self?.user = authResult.user
                    self?.loggedWith = .emailPassword
                    completion(true, nil)
                }
            }
        }
    }
    
    func firebaseEmailPasswordSignIn(email: String,
                                     password: String,
                                     completion: @escaping ((Bool, Error?) -> ())) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                if let _ = authResult {
                    self?.loggedWith = .emailPassword
                    completion(true, nil)
                }
            }
        }
    }
    
    func firebaseSendPasswordReset(email: String, completion: @escaping ((Bool, Error?) -> ())) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    
    // MARK: Phone Auth to be implemented after getting Apple Developer Account
    // MARK: Phone SignIn
    
//    func getPhoneSignInVerificationCode(phoneNumber: String,
//                                        completion: @escaping ((Bool, Error?) -> ())) {
//        phoneProvider
//            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion(false, error)
//                } else {
//                    UserDefaults.standard.set(verificationID, forKey: "phoneVerificationID")
//                    completion(true, error)
//                }
//            }
//    }
//
//    private func getPhoneSignInCredentials(verificationCode: String,
//                                           completion: @escaping ((AuthCredential?, Error?) -> ())) {
//        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
//            let credential = phoneProvider.credential(withVerificationID: verificationID,
//                                                      verificationCode: verificationCode)
//            completion(credential, nil)
//        } else {
//            completion(nil, nil)
//        }
//    }
//
//    func firebasePhoneSignIn(verificationCode: String,
//                             completion: @escaping ((Bool, Error?) -> ())) {
//        getPhoneSignInCredentials(verificationCode: verificationCode) { [weak self] credential, error in
//            if let credential = credential {
//                self?.auth.signIn(with: credential) { (result, error) in
//                    if let error = error {
//                        completion(false, error)
//                    }
//                    completion(true, nil)
//                }
//            } else {
//                completion(false, error)
//            }
//        }
//    }
    
    
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
                    } else {
                        if let result = result {
                            self?.user = result.user
                            self?.loggedWith = .google
                            completion(true, nil)
                        }
                    }
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
                    } else {
                        if let result = result {
                            self?.user = result.user
                            self?.loggedWith = .facebook
                            completion(true, nil)
                        }
                    }
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    
    // MARK: GitHub SignIn
    
    private func getGitHubSignInCredentials(completion: @escaping ((AuthCredential?, Error?) -> ())) {
        gitHubProvider.getCredentialWith(nil) { credential, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(credential, error)
            }
        }
    }
    
    func firebaseGitHubSignIn(completion: @escaping ((Bool, Error?) -> ())) {
        getGitHubSignInCredentials { [weak self] credential, error in
            if let credential = credential {
                self?.auth.signIn(with: credential) { result, error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        if let result = result {
                            self?.user = result.user
                            self?.loggedWith = .github
                            completion(true, nil)
                        }
                    }
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    
    // MARK: Firebase account management
    
    func firebaseSignOut() -> (Bool, Error?) {
        do {
            try auth.signOut()
            self.user = nil
            self.loggedWith = nil
            return (true, nil)
        } catch let signOutError as NSError {
            return (false, signOutError)
        }
    }
    
    func sendRecoveryEmail(email: String, completion: @escaping ((Bool, Error?) -> ())) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error sending recovery email: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Recovery email has been sent")
                completion(true, nil)
            }
        }
    }
    
    func changeEmailAddress(userID: String, oldEmailAddress: String, password: String, newEmailAddress: String, completion: @escaping ((Bool, Error?) -> ())) {
        let credential = EmailAuthProvider.credential(withEmail: oldEmailAddress, password: password)
        
        user?.reauthenticate(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
                completion(false, error)
            } else {
                user?.updateEmail(to: newEmailAddress) { (error) in
                    if let error = error {
                        print("Error changing email address: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func changePassword(emailAddress: String, oldPassword: String, newPassword: String, completion: @escaping ((Bool, Error?) -> ())) {
        let credential = EmailAuthProvider.credential(withEmail: emailAddress, password: oldPassword)
        
        user?.reauthenticate(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
                completion(false, error)
            } else {
                user?.updatePassword(to: newPassword) { (error) in
                    if let error = error {
                        print("Error changing password: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("Successfully changed password")
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func deleteUser(email: String, password: String, completion: @escaping ((Bool, Error?) -> ())) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
                completion(false, error)
            } else {
                user?.delete { (error) in
                    if let error = error {
                        print("Could not delete user: \(error)")
                        completion(false, error)
                    } else {
                        let result = self.firebaseSignOut()
                        completion(result.0, result.1)
                    }
                }
            }
        }
    }
}

extension FirebaseAuthManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
