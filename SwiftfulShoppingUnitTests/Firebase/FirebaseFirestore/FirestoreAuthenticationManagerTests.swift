//
//  FirestoreAuthenticationManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 07/01/2023.
//

@testable import SwiftfulShopping
import XCTest

final class FirestoreAuthenticationManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var error: Error?
    
    private var mockProfile: Profile!
    private var mockShipmentAddress: Address!
    private var mockInvoiceAddress: Address!
    
    // MARK: - Setup

    override func setUpWithError() throws {
        setUpProperties()
    }

    override func tearDownWithError() throws {
        error = nil
        FirebaseAuthManager.client.firebaseSignOut { _ in }
    }
    
    // MARK: - Tests

    func test_FirestoreAuthenticationManager_getUsersUIDs() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get usersUIDs.")
        
        var usersUIDs: [String] = []
        
        FirestoreAuthenticationManager.getUsersUIDs { [self] result in
            switch result {
            case .success(let fetchedUsersUIDs):
                guard let fetchedUsersUIDs = fetchedUsersUIDs else { return XCTFail() }
                usersUIDs = fetchedUsersUIDs
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(usersUIDs.isEmpty)
    }
    
    func test_FirestoreAuthenticationManager_getUsersUsernamesAndEmails() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should get users usernames and emails.")
        
        var usersUsernames: [String] = []
        var usersEmails: [String] = []
        
        FirestoreAuthenticationManager.listenToUsersUsernamesAndEmails { [self] result in
            switch result {
            case .success(let fetchedUsersUsernamesAndEmails):
                guard let fetchedUsersUsernames = fetchedUsersUsernamesAndEmails.0,
                      let fetchedUsersEmails = fetchedUsersUsernamesAndEmails.1 else { return XCTFail() }
                usersUsernames = fetchedUsersUsernames
                usersEmails = fetchedUsersEmails
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(usersUsernames.isEmpty)
        XCTAssertFalse(usersEmails.isEmpty)
    }
    
    func test_FirestoreAuthenticationManager_createProfile() {
        let createExpectation: XCTestExpectation = XCTestExpectation(description: "Should create user profile.")
        
        FirestoreAuthenticationManager.createProfile(profile: mockProfile) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch created user profile.")
        
        FirestoreAuthenticationManager.db
            .collection(DatabaseCollections.profiles.rawValue)
            .document(mockProfile.id)
            .getDocument { [self] documentSnapshot, errorOccured in
                if let errorOccured = errorOccured {
                    error = errorOccured
                }
                
                fetchExpectation.fulfill()
            }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
    }
    
    func test_FirestoreAuthenticationManager_createShipmentAddress() {
        let createExpectation: XCTestExpectation = XCTestExpectation(description: "Should create shipment address.")
        
        FirestoreAuthenticationManager.createShipmentAddress(shipmentAddress: mockShipmentAddress) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch created shipment address.")
        
        FirestoreAuthenticationManager.db
            .collection(DatabaseCollections.shipmentAddresses.rawValue)
            .document(mockShipmentAddress.id)
            .getDocument { [self] documentSnapshot, errorOccured in
                if let errorOccured = errorOccured {
                    error = errorOccured
                }
                
                fetchExpectation.fulfill()
            }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
    }
    
    func test_FirestoreAuthenticationManager_createInvoiceAddress() {
        let createExpectation: XCTestExpectation = XCTestExpectation(description: "Should create invoice address.")
        
        FirestoreAuthenticationManager.createInvoiceAddress(invoiceAddress: mockInvoiceAddress) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch created invoice address.")
        
        FirestoreAuthenticationManager.db
            .collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(mockInvoiceAddress.id)
            .getDocument { [self] documentSnapshot, errorOccured in
                if let errorOccured = errorOccured {
                    error = errorOccured
                }
                
                fetchExpectation.fulfill()
            }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
    }
    
    private func setUpProperties() {
        mockShipmentAddress = Address(id: "testShipmentAddressID",
                                      userID: "testProfileID",
                                      fullName: "testFullName",
                                      streetName: "testStreetName",
                                      streetNumber: "testStreetNumber",
                                      apartmentNumber: "testApartmentNumber",
                                      zipCode: "testZipCode",
                                      city: "testCity",
                                      country: "testCountry",
                                      isDefaultAddress: true,
                                      isInvoiceAddress: false)
        
        mockInvoiceAddress = Address(id: "testInvoiceAddressID",
                                     userID: "testProfileID",
                                     fullName: "testFullName",
                                     streetName: "testStreetName",
                                     streetNumber: "testStreetNumber",
                                     apartmentNumber: "testApartmentNumber",
                                     zipCode: "testZipCode",
                                     city: "testCity",
                                     country: "testCountry",
                                     isDefaultAddress: true,
                                     isInvoiceAddress: true)
        
        mockProfile = Profile(id: "testProfileID",
                              fullName: "testFullName",
                              username: "testUsername",
                              email: "test@email.to",
                              country: Countries.poland,
                              defaultShipmentAddress: mockShipmentAddress,
                              shipmentAddresses: [mockShipmentAddress],
                              invoiceAddress: mockInvoiceAddress,
                              defaultShippingMethod: ShippingMethod.allCases[0],
                              defaultPaymentMethod: PaymentMethod.allCases[0],
                              createdWith: SignInMethod.allCases[0])
    }
}
