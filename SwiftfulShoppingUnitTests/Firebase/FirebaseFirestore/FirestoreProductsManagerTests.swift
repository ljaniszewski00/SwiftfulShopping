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
        
        let appleProducts = products.filter { $0.company == "Apple Inc." }
        
        XCTAssertFalse(appleProducts.isEmpty)
    }
    
    func test_FirestoreProductsManager_checkProductsAvailability() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should check if products are available.")
        
        let productsToCheck: [String: Int] = ["7vHPvsjhC2N3DszzpejX": 2,
                                              "LQHU7yJplIXugoPiLucR": 1000]
        
        var checkingResult: [String: Bool] = [:]
        
        FirestoreProductsManager.checkProductsAvailability(productsIDsWithQuantity: productsToCheck) { [self] result in
            switch result {
            case .success(let fetchedCheckingResult):
                checkingResult = fetchedCheckingResult
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(checkingResult.isEmpty)
        
        guard let firstProductResult = checkingResult["7vHPvsjhC2N3DszzpejX"] else { return XCTFail() }
        XCTAssertTrue(firstProductResult)
        guard let secondProductResult = checkingResult["LQHU7yJplIXugoPiLucR"] else { return XCTFail() }
        XCTAssertTrue(secondProductResult)
    }
    
    func test_FirestoreProductsManager_checkProductAvailability() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should check if product is available.")
        
        let productIDToCheck: String = "7vHPvsjhC2N3DszzpejX"
        
        var checkingResult: Bool = false
        
        FirestoreProductsManager.checkProductAvailability(productID: productIDToCheck,
                                                          quantity: 2) { [self] result in
            switch result {
            case .success(let fetchedCheckingResult):
                checkingResult = fetchedCheckingResult
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertTrue(checkingResult)
    }
    
    private func setUpProperties() {
        
    }
}
