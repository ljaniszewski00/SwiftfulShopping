//
//  FirebaseAuthManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 04/01/2023.
//

@testable import SwiftfulShopping
import XCTest

final class FirebaseAuthManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var error: Error?
    
    private let testUserUID: String = "SGvA0fZMUwQJFY6YL0CoERsMt3T2"
    
    private let emailForNewUser: String = "test@email.to"
    private let usedEmail: String = "permanent@testuser.com"
    private let emailToChangeFor: String = "email2@email2.to"
    
    private let passwordForNewUser: String = "testPassword123@"
    private let usedPassword: String = "Haslo123"
    private let passwordToChangeFor: String = "Haslo321"
    
    // MARK: - Setup

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        error = nil
        FirebaseAuthManager.client.firebaseSignOut { _ in }
    }
    
    // MARK: - Tests

    func test_FirebaseAuthManager_firebaseSignUp_shouldSucceed() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should be signed up.")
        
        FirebaseAuthManager.client.firebaseSignUp(email: emailForNewUser,
                                                  password: passwordForNewUser) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertNotNil(FirebaseAuthManager.client.user)
        XCTAssertEqual(FirebaseAuthManager.client.loggedWith, .emailPassword)
    }
    
    func test_FirebaseAuthManager_firebaseSignUp_deleteUser_shouldSucceed() {
        let accountShouldBeDeletedExpectation: XCTestExpectation = XCTestExpectation(description: "Should be deleted.")
        
        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: emailForNewUser,
                                                               password: passwordForNewUser) { [self] result in
            FirebaseAuthManager.client.deleteUser(email: emailForNewUser,
                                                  password: passwordForNewUser) { [self] result in
                switch result {
                case .success:
                    break
                case .failure(let errorOccured):
                    error = errorOccured
                }
                
                accountShouldBeDeletedExpectation.fulfill()
            }
            
            wait(for: [accountShouldBeDeletedExpectation], timeout: 4)
            
            XCTAssertNil(error)
            XCTAssertNil(FirebaseAuthManager.client.user)
            XCTAssertNil(FirebaseAuthManager.client.loggedWith)
            
            let userShouldNotBeAbleToSignIn: XCTestExpectation = XCTestExpectation(description: "Should not be able to sign in.")
            
            FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: emailForNewUser,
                                                                   password: passwordForNewUser) { [self] result in
                switch result {
                case .success:
                    break
                case .failure(let errorOccured):
                    error = errorOccured
                }
                
                userShouldNotBeAbleToSignIn.fulfill()
            }
            
            wait(for: [userShouldNotBeAbleToSignIn], timeout: 4)
            
            XCTAssertNil(error)
            XCTAssertNil(FirebaseAuthManager.client.user)
            XCTAssertNil(FirebaseAuthManager.client.loggedWith)
        }
    }
    
    func test_FirebaseAuthManager_firebaseEmailPasswordSignIn_shouldSucceed_then_logout() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should be signed in.")
        
        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: usedEmail,
                                                               password: usedPassword) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        XCTAssertNil(error)
        XCTAssertNotNil(FirebaseAuthManager.client.user)
        XCTAssertEqual(FirebaseAuthManager.client.loggedWith, .emailPassword)
    }
    
    func test_FirebaseAuthManager_firebaseSignOut_shouldSucceed() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should be signed out.")
        
        FirebaseAuthManager.client.firebaseSignOut { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        XCTAssertNil(error)
        XCTAssertNil(FirebaseAuthManager.client.user)
        XCTAssertNil(FirebaseAuthManager.client.loggedWith)
    }
    
    func test_FirebaseAuthManager_firebaseChangeEmailAddress_shouldSucceed_thenRevertPreviousOne() {
        let emailChangeExpectation: XCTestExpectation = XCTestExpectation(description: "Email should be changed.")
        
        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: usedEmail,
                                                               password: usedPassword) { [self] result in
            FirebaseAuthManager.client.changeEmailAddress(userID: testUserUID,
                                                          oldEmailAddress: usedEmail,
                                                          password: usedPassword,
                                                          newEmailAddress: emailToChangeFor,
                                                          completion: { [self] result in
                switch result {
                case .success:
                    break
                case .failure(let errorOccured):
                    error = errorOccured
                }
                
                emailChangeExpectation.fulfill()
                
                FirebaseAuthManager.client.firebaseSignOut { _ in }
            })
        }
        
        wait(for: [emailChangeExpectation], timeout: 4)
        
        let signInWithNewEmailExpectation: XCTestExpectation = XCTestExpectation(description: "User should sign in with new email address.")
        
        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: emailToChangeFor,
                                                               password: usedPassword) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            signInWithNewEmailExpectation.fulfill()
        }
        
        wait(for: [signInWithNewEmailExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertNotNil(FirebaseAuthManager.client.user)
        XCTAssertEqual(FirebaseAuthManager.client.loggedWith, .emailPassword)
        
        let emailRevertExpectation: XCTestExpectation = XCTestExpectation(description: "Email should be reverted back to the previous one.")
        
        FirebaseAuthManager.client.changeEmailAddress(userID: testUserUID,
                                                      oldEmailAddress: emailToChangeFor,
                                                      password: usedPassword,
                                                      newEmailAddress: usedEmail,
                                                      completion: { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            emailRevertExpectation.fulfill()
        })
        
        wait(for: [emailRevertExpectation], timeout: 4)
    }
    
    func test_FirebaseAuthManager_firebaseChangePassword_shouldSucceed_thenRevertPreviousOne() {
        let passwordChangeExpectation: XCTestExpectation = XCTestExpectation(description: "Password should be changed.")
        
        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: usedEmail,
                                                               password: usedPassword) { [self] result in
            FirebaseAuthManager.client.changePassword(emailAddress: usedEmail,
                                                      oldPassword: usedPassword,
                                                      newPassword: passwordToChangeFor) { [self] result in
                switch result {
                case .success:
                    break
                case .failure(let errorOccured):
                    error = errorOccured
                }
                
                passwordChangeExpectation.fulfill()
                
                FirebaseAuthManager.client.firebaseSignOut { _ in }
            }
        }
        
        wait(for: [passwordChangeExpectation], timeout: 4)
        
        let signInWithNewPassword: XCTestExpectation = XCTestExpectation(description: "User should sign in with new password.")
        
        FirebaseAuthManager.client.firebaseEmailPasswordSignIn(email: usedEmail,
                                                               password: passwordToChangeFor) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            signInWithNewPassword.fulfill()
        }
        
        wait(for: [signInWithNewPassword], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertNotNil(FirebaseAuthManager.client.user)
        XCTAssertEqual(FirebaseAuthManager.client.loggedWith, .emailPassword)
        
        let passwordRevertExpectation: XCTestExpectation = XCTestExpectation(description: "Password should be reverted back to the previous one.")
        
        FirebaseAuthManager.client.changePassword(emailAddress: usedEmail,
                                                  oldPassword: passwordToChangeFor,
                                                  newPassword: usedPassword) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            passwordRevertExpectation.fulfill()
        }
        
        wait(for: [passwordRevertExpectation], timeout: 4)
    }
}
