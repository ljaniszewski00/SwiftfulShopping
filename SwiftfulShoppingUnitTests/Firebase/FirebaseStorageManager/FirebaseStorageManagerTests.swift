//
//  FirebaseStorageManagerTests.swift
//  SwiftfulShoppingTests
//
//  Created by Łukasz Janiszewski on 04/01/2023.
//

@testable import SwiftfulShopping
import Firebase
import XCTest

final class FirebaseStorageManagerTests: XCTestCase {
    
    // MARK: Properties
    
    private var imageName: String = "blank_profile_image"
    private var userID: String = "test_user_id"
    private var error: Error?
    
    // MARK: Setup

    override func setUpWithError() throws {
        error = nil
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: Tests

    func test_FirebaseStorageManager_uploadImageToStorage_shouldSucceed_then_deleteImageFromStorage() {
        guard let image = UIImage(named: imageName) else { return }
        
        var imageUUID: String?
        let expectation: XCTestExpectation = XCTestExpectation(description: "ImageUUID should be fetched.")
        
        FirebaseStorageManager.uploadImageToStorage(image: image,
                                                    userID: userID) { [self] result in
            switch result {
            case .success(let fetchedImageUUID):
                guard let fetchedImageUUID = fetchedImageUUID else { return }
                imageUUID = fetchedImageUUID
                expectation.fulfill()
                FirebaseStorageManager.deleteImageFromStorage(userID: userID,
                                                              imageURL: fetchedImageUUID) { _ in }
            case .failure(let errorOccured):
                error = errorOccured
            }
        }
        
        wait(for: [expectation], timeout: 4)
        XCTAssertNil(error)
        XCTAssertNotNil(imageUUID)
        XCTAssertFalse(imageUUID!.isEmpty)
    }
    
    func test_FirebaseStorageManager_downloadImageFromStorage_shouldSucceed() {
        var image: UIImage?
        let expectation: XCTestExpectation = XCTestExpectation(description: "Image should be fetched.")
        
        FirebaseStorageManager.downloadImageFromStorage(userID: "W9UQoichE0UNZfvCnIPxuCBgL283",
                                                        imageURL: "5F9F3C8F-3CEF-4465-AD22-50034D16875C") { [self] result in
            switch result {
            case .success(let fetchedImage):
                guard let fetchedImage = fetchedImage else { return }
                image = fetchedImage
                expectation.fulfill()
            case .failure(let errorOccured):
                error = errorOccured
            }
        }
        
        wait(for: [expectation], timeout: 4)
        XCTAssertNil(error)
        XCTAssertNotNil(image)
        XCTAssertNotEqual(image?.size, CGSize.zero)
    }
    
    func test_FirebaseStorageManager_downloadOnboardingImagesFromStorage() {
        var onboardingImageModels: [OnboardingImageModel] = []
        let expectation: XCTestExpectation = XCTestExpectation(description: "onboardingImageModels count should be equal to 10.")
        
        FirebaseStorageManager.downloadOnboardingImagesFromStorage { [self] result in
            switch result {
            case .success(let fetchedOnboardingImageModels):
                onboardingImageModels = fetchedOnboardingImageModels
                expectation.fulfill()
            case .failure(let errorOccured):
                error = errorOccured
            }
        }
        
        wait(for: [expectation], timeout: 4)
        XCTAssertNil(error)
        XCTAssertEqual(onboardingImageModels.count, 10)
    }
}
