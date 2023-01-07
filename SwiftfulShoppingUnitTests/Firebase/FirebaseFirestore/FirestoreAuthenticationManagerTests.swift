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
    
    private let mockProfile: Profile = Profile(id: "testProfileID",
                                               fullName: "testFullName",
                                               username: "testUsername",
                                               email: "test@email.to",
                                               country: Countries.poland,
                                               defaultShipmentAddress: <#T##Address#>,
                                               shipmentAddresses: <#T##[Address]#>,
                                               invoiceAddress: <#T##Address#>,
                                               defaultShippingMethod: ShippingMethod.allCases[0],
                                               defaultPaymentMethod: PaymentMethod.allCases[0],
                                               createdWith: SignInMethod.allCases[0])
    
    private let mockShipmentAddress: Address = Address(id: "testShipmentAddressID",
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
    
    private let mockInvoiceAddress: Address = Address(id: "testInvoiceAddressID",
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
    
    // MARK: - Setup

    override func setUpWithError() throws {
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
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should create user profile.")
        
        FirestoreAuthenticationManager.createProfile(profile: mockProfile) { [self] result in
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
        
        
    }
}
