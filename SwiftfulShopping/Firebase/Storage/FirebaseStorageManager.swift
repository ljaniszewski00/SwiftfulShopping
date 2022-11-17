//
//  FirebaseStorageManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 05/10/2022.
//

import Foundation
import FirebaseStorage
import UIKit

struct FirebaseStorageManager {
    static let storageRef = Storage.storage().reference()
    
    private init() {}
    
    static func uploadImageToStorage(image: UIImage,
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
    
    static func deleteImageFromStorage(userID: String,
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
    
    static func getDownloadURLForImage(userID: String,
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
    
    static func downloadImageFromStorage(userID: String,
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
