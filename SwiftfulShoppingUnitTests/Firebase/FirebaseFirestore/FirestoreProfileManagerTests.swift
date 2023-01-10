//
//  FirestoreAuthenticationManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 07/01/2023.
//

@testable import SwiftfulShopping
import XCTest

final class FirestoreProfileManagerTests: XCTestCase {
    
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

    func test_FirestoreProfileManager_getUserProfile() {
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
        
        var fetchedProfile: Profile?
        
        FirestoreProfileManager.getUserProfile(userID: mockProfile.id) { [self] result in
            switch result {
            case .success(let profile):
                fetchedProfile = profile
            case .failure(let errorOccured):
                error = errorOccured
            }
        }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertNotNil(fetchedProfile)
    }
    
    func test_FirestoreProfileManager_updateProfileData() {
        let updateExpectation: XCTestExpectation = XCTestExpectation(description: "Should update user profile.")
        
        let profileDataToUpdate: [String: Any] = [
            "fullName": "testFullName2"
        ]
        
        FirestoreProfileManager.updateProfileData(profileID: mockProfile.id,
                                                  profileDataToUpdate: profileDataToUpdate) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            updateExpectation.fulfill()
        }
        
        wait(for: [updateExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch updated user profile.")
        
        var fetchedProfile: Profile?
        
        FirestoreProfileManager.getUserProfile(userID: mockProfile.id) { [self] result in
            switch result {
            case .success(let profile):
                fetchedProfile = profile
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertEqual(fetchedProfile?.fullName, "testFullName2")
    }
    
    func test_FirestoreProfileManager_updateProfileImageURL() {
        let updateExpectation: XCTestExpectation = XCTestExpectation(description: "Should update user profile image URL.")
        
        FirestoreProfileManager.updateProfileImageURL(profileID: mockProfile.id,
                                                      imageURL: "testImageURL2") { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            updateExpectation.fulfill()
        }
        
        wait(for: [updateExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch updated user profile.")
        
        var fetchedProfile: Profile?
        
        FirestoreProfileManager.getUserProfile(userID: mockProfile.id) { [self] result in
            switch result {
            case .success(let profile):
                fetchedProfile = profile
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertEqual(fetchedProfile?.imageURL, "testImageURL2")
    }
    
    func test_FirestoreProfileManager_updateEmail() {
        let updateExpectation: XCTestExpectation = XCTestExpectation(description: "Should update user email.")
        
        FirestoreProfileManager.updateEmail(newEmail: "testEmail2",
                                            profile: mockProfile) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            updateExpectation.fulfill()
        }
        
        wait(for: [updateExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch updated user profile.")
        
        var fetchedProfile: Profile?
        
        FirestoreProfileManager.getUserProfile(userID: mockProfile.id) { [self] result in
            switch result {
            case .success(let profile):
                fetchedProfile = profile
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertEqual(fetchedProfile?.email, "testEmail2")
    }
    
    func test_FirestoreProfileManager_changeDefaultPaymentMethod() {
        let updateExpectation: XCTestExpectation = XCTestExpectation(description: "Should update user default payment method.")
        
        FirestoreProfileManager.changeDefaultPaymentMethod(userID: mockProfile.id,
                                                           newDefaultPaymentMethod: "Credit Card") { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            updateExpectation.fulfill()
        }
        
        wait(for: [updateExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        let fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should fetch updated user profile.")
        
        var fetchedProfile: Profile?
        
        FirestoreProfileManager.getUserProfile(userID: mockProfile.id) { [self] result in
            switch result {
            case .success(let profile):
                fetchedProfile = profile
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertEqual(fetchedProfile?.defaultPaymentMethod, .creditCard)
    }
    
    func test_FirestoreProfileManager_deleteProfileAndShipmentAddressAndInvoiceAddress() {
        var deleteExpectation: XCTestExpectation = XCTestExpectation(description: "Should delete user profile.")
        
        FirestoreProfileManager.deleteProfile(profile: mockProfile) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        var fetchExpectation: XCTestExpectation = XCTestExpectation(description: "Should not fetch user profile.")
        
        var fetchedProfile: Profile?
        
        FirestoreProfileManager.getUserProfile(userID: mockProfile.id) { [self] result in
            switch result {
            case .success(let profile):
                fetchedProfile = profile
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertNil(fetchedProfile)
        
        deleteExpectation = XCTestExpectation(description: "Should delete shipment address.")
        
        FirestoreProfileManager.deleteShipmentAddress(shipmentAddress: mockShipmentAddress) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        fetchExpectation = XCTestExpectation(description: "Should not fetch shipment address.")
        
        var documentExists: Bool = false
        
        FirestoreAuthenticationManager.db
            .collection(DatabaseCollections.shipmentAddresses.rawValue)
            .document(mockShipmentAddress.id)
            .getDocument { [self] documentSnapshot, errorOccured in
                if let errorOccured = errorOccured {
                    error = errorOccured
                }
                
                if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    documentExists = true
                }
                
                fetchExpectation.fulfill()
            }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(documentExists)
        
        deleteExpectation = XCTestExpectation(description: "Should delete invoice address.")
        
        FirestoreProfileManager.deleteInvoiceAddress(invoiceAddress: mockShipmentAddress) { [self] result in
            switch result {
            case .success:
                break
            case .failure(let errorOccured):
                error = errorOccured
            }
            
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: 4)
        
        XCTAssertNil(error)
        
        fetchExpectation = XCTestExpectation(description: "Should not fetch invoice address.")
        
        documentExists = false
        
        FirestoreAuthenticationManager.db
            .collection(DatabaseCollections.invoiceAddresses.rawValue)
            .document(mockInvoiceAddress.id)
            .getDocument { [self] documentSnapshot, errorOccured in
                if let errorOccured = errorOccured {
                    error = errorOccured
                }
                
                if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    documentExists = true
                }
                
                fetchExpectation.fulfill()
            }
        
        wait(for: [fetchExpectation], timeout: 4)
        
        XCTAssertNil(error)
        XCTAssertFalse(documentExists)
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
