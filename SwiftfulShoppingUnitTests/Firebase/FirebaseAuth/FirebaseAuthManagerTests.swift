//
//  FirebaseStorageManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 04/01/2023.
//

@testable import SwiftfulShopping
import Firebase
import XCTest

final class FirebaseAuthManagerTests: XCTestCase {
    
    // MARK: Properties
    
    private var error: Error?
    
    private var email: String = "test@email.to"
    private var usedEmail: String = "email@email.to"
    private var emailToChangeFor: String = "email2@email2.to"
    
    private var password: String = "testPassword123@"
    private var usedPassword: String = "Haslo123"
    private var passwordToChangeFor: String = "Haslo321"
    
    // MARK: Setup

    override func setUpWithError() throws {
        error = nil
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: Tests

    func test_FirebaseAuthManager_firebaseSignUp_shouldSucceed_then_deleteUser() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should be signed up.")
        
        FirebaseAuthManager.client.firebaseSignUp(email: email,
                                                  password: password) { [self] result in
            switch result {
            case .success:
                expectation.fulfill()
                
                FirebaseAuthManager.client.deleteUser(email: email,
                                                      password: password) { _ in }
            case .failure(let errorOccured):
                error = errorOccured
            }
        }
        
        wait(for: [expectation], timeout: 4)
        XCTAssertNil(error)
        XCTAssertNotNil(FirebaseAuthManager.client.user)
        XCTAssertEqual(FirebaseAuthManager.client.loggedWith, .emailPassword)
    }
}
