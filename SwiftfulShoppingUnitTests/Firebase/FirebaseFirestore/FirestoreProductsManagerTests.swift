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
        XCTAssertFalse(secondProductResult)
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
    
    func test_FirestoreProductsManager_getRatings() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get ratings.")
        
        var ratings: [ProductRating] = []
        
        FirestoreProductsManager.getRatings { [self] result in
            switch result {
            case .success(let fetchedRatings):
                guard let fetchedRatings = fetchedRatings else { return XCTFail() }
                ratings = fetchedRatings
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(ratings.isEmpty)
    }
    
    func test_FirestoreProductsManager_getProductRatings() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get product ratings.")
        
        var ratings: [ProductRating] = []
        
        let productIDToCheck: String = "7vHPvsjhC2N3DszzpejX"
        
        FirestoreProductsManager.getProductRatings(productID: productIDToCheck) { [self] result in
            switch result {
            case .success(let fetchedRatings):
                guard let fetchedRatings = fetchedRatings else { return XCTFail() }
                ratings = fetchedRatings
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(ratings.isEmpty)
    }
    
    func test_FirestoreProductsManager_getDiscounts() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get discounts.")
        
        var discounts: [Discount] = []
        
        FirestoreProductsManager.getDiscounts { [self] result in
            switch result {
            case .success(let fetchedDiscounts):
                guard let fetchedDiscounts = fetchedDiscounts else { return XCTFail() }
                discounts = fetchedDiscounts
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(discounts.isEmpty)
    }
    
    func test_FirestoreProductsManager_getDiscountsFor() {
        let firstExpectation: XCTestExpectation = XCTestExpectation(description: "Should not get discounts for first product.")
        
        var discounts: [Discount] = []
        
        let firstProductIDToCheck: String = "7vHPvsjhC2N3DszzpejX"
        
        FirestoreProductsManager.getDiscountsFor(productID: firstProductIDToCheck) { [self] result in
            switch result {
            case .success(let fetchedDiscounts):
                guard let fetchedDiscounts = fetchedDiscounts else { return XCTFail() }
                discounts = fetchedDiscounts
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            firstExpectation.fulfill()
        }
        
        wait(for: [firstExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertTrue(discounts.isEmpty)
        
        let secondExpectation: XCTestExpectation = XCTestExpectation(description: "Should get discounts for second product.")
        
        discounts = []
        
        let secondProductIDToCheck: String = "BJll5oJjsBoq0tb6Ad8v"
        
        FirestoreProductsManager.getDiscountsFor(productID: secondProductIDToCheck) { [self] result in
            switch result {
            case .success(let fetchedDiscounts):
                guard let fetchedDiscounts = fetchedDiscounts else { return XCTFail() }
                discounts = fetchedDiscounts
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            secondExpectation.fulfill()
        }
        
        wait(for: [secondExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(discounts.isEmpty)
    }
    
    func test_FirestoreProductsManager_getTrendingSearches() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get trending searches.")
        
        var trendingSearches: [String] = []
        
        FirestoreProductsManager.getTrendingSearches { [self] result in
            switch result {
            case .success(let fetchedTrendingSearches):
                guard let fetchedTrendingSearches = fetchedTrendingSearches else { return XCTFail() }
                trendingSearches = fetchedTrendingSearches
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(trendingSearches.isEmpty)
    }
}
