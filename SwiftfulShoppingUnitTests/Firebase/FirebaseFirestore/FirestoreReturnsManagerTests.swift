//
//  FirestoreAuthenticationManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 15/01/2023.
//

@testable import SwiftfulShopping
import XCTest

final class FirestoreReturnsManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var error: Error?
    
    // MARK: - Setup

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        error = nil
        FirebaseAuthManager.client.firebaseSignOut { _ in }
    }
    
    // MARK: - Tests

    func test_FirestoreReturnsManager_getUserReturns() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get user returns.")
        
        var returns: [Return] = []
        
        let userID: String = "W9UQoichE0UNZfvCnIPxuCBgL283"
        
        FirestoreReturnsManager.getUserReturns(userID: userID) { [self] result in
            switch result {
            case .success(let fetchedReturns):
                guard let fetchedReturns = fetchedReturns else { return XCTFail() }
                returns = fetchedReturns
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(returns.isEmpty)
    }
}
