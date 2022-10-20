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
                        completion: @escaping ((VoidResult) -> ())) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let authResult = authResult {
                    self?.user = authResult.user
                    self?.loggedWith = .emailPassword
                    completion(.success)
                }
            }
        }
    }
    
    func firebaseEmailPasswordSignIn(email: String,
                                     password: String,
                                     completion: @escaping ((VoidResult) -> ())) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let _ = authResult {
                    self?.loggedWith = .emailPassword
                    completion(.success)
                }
            }
        }
    }
    
    func firebaseSendPasswordReset(email: String,
                                   completion: @escaping ((VoidResult) -> ())) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }
    
    
    // MARK: Phone Auth to be implemented after getting Apple Developer Account
    // MARK: Phone SignIn
    
//    func getPhoneSignInVerificationCode(phoneNumber: String,
//                                        completion: @escaping ((VoidResult) -> ())) {
//        phoneProvider
//            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion(.failure(error))
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
//                             completion: @escaping ((VoidResult) -> ())) {
//        getPhoneSignInCredentials(verificationCode: verificationCode) { [weak self] credential, error in
//            if let credential = credential {
//                self?.auth.signIn(with: credential) { (result, error) in
//                    if let error = error {
//                        completion(.failure(error))
//                    }
//                    completion(.success)
//                }
//            } else {
//                completion(.failure(error))
//            }
//        }
//    }
    
    
    // MARK: Google SignIn
    
    private func getGoogleSignInCredentials(completion: @escaping ((Result<AuthCredential?, Error>) -> ())) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: EmptyView().getRootViewController()) { user, error in
                    
            if let error = error {
                completion(.failure(error))
            } else {
                if let authentication = user?.authentication, let idToken = authentication.idToken {
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: authentication.accessToken)

                    // Use the credential to authenticate with Firebase
                    completion(.success(credential))
                }
            }
        }
    }
    
    func firebaseGoogleSignIn(completion: @escaping ((VoidResult) -> ())) {
        getGoogleSignInCredentials { [weak self] getCredentialsResult in
            switch getCredentialsResult {
            case .success(let credential):
                if let credential = credential {
                    self?.auth.signIn(with: credential) { (result, error) in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            if let result = result {
                                self?.user = result.user
                                self?.loggedWith = .google
                                completion(.success)
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: Facebook SignIn
    
    private func getFacebookSignInCredentials(completion: @escaping ((Result<AuthCredential?, Error>) -> ())) {
        LoginManager().logIn(permissions: ["email"],
                             from: nil) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let result = result, let token = result.token {
                    let tokenString = token.tokenString
                    let credential = FacebookAuthProvider.credential(withAccessToken:
                                                                        tokenString)
                    completion(.success(credential))
                }
            }
        }
    }
    
    func firebaseFacebookSignIn(completion: @escaping ((VoidResult) -> ())) {
        getFacebookSignInCredentials { [weak self] getCredentialsResult in
            switch getCredentialsResult {
            case .success(let credential):
                if let credential = credential {
                    self?.auth.signIn(with: credential) { (result, error) in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            if let result = result {
                                self?.user = result.user
                                self?.loggedWith = .facebook
                                completion(.success)
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: GitHub SignIn
    
    private func getGitHubSignInCredentials(completion: @escaping ((Result<AuthCredential?, Error>) -> ())) {
        gitHubProvider.getCredentialWith(nil) { credential, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(credential))
            }
        }
    }
    
    func firebaseGitHubSignIn(completion: @escaping ((VoidResult) -> ())) {
        getGitHubSignInCredentials { [weak self] getCredentialsResult in
            switch getCredentialsResult {
            case .success(let credential):
                if let credential = credential {
                    self?.auth.signIn(with: credential) { result, error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            if let result = result {
                                self?.user = result.user
                                self?.loggedWith = .github
                                completion(.success)
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: Firebase account management
    
    func firebaseSignOut() -> VoidResult {
        do {
            try auth.signOut()
            self.user = nil
            self.loggedWith = nil
            return .success
        } catch let signOutError as NSError {
            return .failure(signOutError)
        }
    }
    
    func sendRecoveryEmail(email: String, completion: @escaping ((VoidResult) -> ())) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error sending recovery email: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Recovery email has been sent")
                completion(.success)
            }
        }
    }
    
    func changeEmailAddress(userID: String, oldEmailAddress: String, password: String, newEmailAddress: String, completion: @escaping ((VoidResult) -> ())) {
        let credential = EmailAuthProvider.credential(withEmail: oldEmailAddress, password: password)
        
        user?.reauthenticate(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
                completion(.failure(error))
            } else {
                user?.updateEmail(to: newEmailAddress) { (error) in
                    if let error = error {
                        print("Error changing email address: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        completion(.success)
                    }
                }
            }
        }
    }
    
    func changePassword(emailAddress: String, oldPassword: String, newPassword: String, completion: @escaping ((VoidResult) -> ())) {
        let credential = EmailAuthProvider.credential(withEmail: emailAddress, password: oldPassword)
        
        user?.reauthenticate(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
                completion(.failure(error))
            } else {
                user?.updatePassword(to: newPassword) { (error) in
                    if let error = error {
                        print("Error changing password: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("Successfully changed password")
                        completion(.success)
                    }
                }
            }
        }
    }
    
    func deleteUser(email: String, password: String, completion: @escaping ((VoidResult) -> ())) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
                completion(.failure(error))
            } else {
                user?.delete { (error) in
                    if let error = error {
                        print("Could not delete user: \(error)")
                        completion(.failure(error))
                    } else {
                        let result = self.firebaseSignOut()
                        completion(.success)
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
