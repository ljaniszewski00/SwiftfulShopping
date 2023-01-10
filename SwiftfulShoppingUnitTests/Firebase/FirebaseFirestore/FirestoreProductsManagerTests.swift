//
//  FirestoreAuthenticationManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 10/01/2023.
//

@testable import SwiftfulShopping
import XCTest

final class FirestoreProductsManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var error: Error?
    
    // MARK: - Setup

    override func setUpWithError() throws {
        setUpProperties()
    }

    override func tearDownWithError() throws {
        error = nil
        FirebaseAuthManager.client.firebaseSignOut { _ in }
    }
    
    // MARK: - Tests

    func test_FirestoreProductsManager_getProducts() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get products.")
        
        var products: [Product] = []
        
        FirestoreProductsManager.getProducts { [self] result in
            switch result {
            case .success(let fetchedProducts):
                guard let fetchedProducts = fetchedProducts else { return XCTFail() }
                products = fetchedProducts
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(products.isEmpty)
    }
    
    private func setUpProperties() {
        
    }
}
