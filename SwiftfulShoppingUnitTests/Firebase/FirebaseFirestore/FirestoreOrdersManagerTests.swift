//
//  FirestoreAuthenticationManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 15/01/2023.
//

@testable import SwiftfulShopping
import XCTest

final class FirestoreOrdersManagerTests: XCTestCase {
    
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

    func test_FirestoreOrdersManager_getUserOrders() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get user orders.")
        
        var orders: [Order] = []
        
        let userID: String = "W9UQoichE0UNZfvCnIPxuCBgL283"
        
        FirestoreOrdersManager.getUserOrders(userID: userID) { [self] result in
            switch result {
            case .success(let fetchedOrders):
                guard let fetchedOrders = fetchedOrders else { return XCTFail() }
                orders = fetchedOrders
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(orders.isEmpty)
    }
}
