//
//  FirebaseStorageManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 05/10/2022.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageManager: ObservableObject {
    private let storageRef = Storage.storage().reference()
    
    static var client: FirebaseStorageManager = {
        FirebaseStorageManager()
    }()
    
    private init() {}
    
    func uploadImageToStorage(image: UIImage,
                              userID: String,
                              completion: @escaping ((Result<String?, Error>) -> ())) {
        let imageUUID = UUID().uuidString
        let userImagesStorageRef = storageRef.child("profileImages/\(userID)/\(imageUUID)")
        
        let data = image.jpegData(compressionQuality: 1)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        metadata.customMetadata = ["userID": userID]
        
        if let data = data {
            userImagesStorageRef.putData(data, metadata: metadata) { _, error in
                if let error = error {
                    print("Error uploading photo: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    completion(.success(imageUUID))
                }
            }
        }
    }
    
    func deleteImageFromStorage(userID: String,
                                imageURL: String,
                                completion: @escaping ((VoidResult) -> ())) {
        let userImagesStorageRef = storageRef.child("profileImages/\(userID)/\(imageURL)")

        userImagesStorageRef.delete() { (error) in
            if let error = error {
                print("Error deleting image from storage: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully deleted image from storage")
                completion(.success)
            }
        }
    }
    
    func getDownloadURLForImage(userID: String,
                                imageURL: String,
                                completion: @escaping ((Result<URL?, Error>) -> ())) {
        let path = "profileImages/\(userID)/\(imageURL)"
        let userImagesStorageRef = storageRef.child(path)
        
        userImagesStorageRef.downloadURL() { url, error in
            if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(url))
            }
        }
    }
    
    func downloadImageFromStorage(userID: String,
                                  imageURL: String,
                                  completion: @escaping ((Result<UIImage?, Error>) -> ())) {
        let userImagesStorageRef = storageRef.child("profileImages/\(userID)/\(imageURL)")
        
        userImagesStorageRef.getData(maxSize: 1 * 100 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading file: ", error.localizedDescription)
                completion(.failure(error))
            } else {
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                }
            }
        }
    }
}

extension FirebaseStorageManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
