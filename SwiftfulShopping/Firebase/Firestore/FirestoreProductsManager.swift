//
//  FirestoreProductsManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 12/10/2022.
//

import Foundation
import Firebase

class FirestoreProductsManager: ObservableObject {
    private let db = Firestore.firestore()
    
    static var client: FirestoreProductsManager = {
        FirestoreProductsManager()
    }()
    
    private init() {}
    
    
    // MARK: SELECT DATABASE OPERATIONS
    
    func getProducts(completion: @escaping ((Result<[Product]?, Error>) -> ())) {
        let languageCode = Locale.current.languageCode
        
        db.collection(DatabaseCollections.products.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching products data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    var dispatchGroup: DispatchGroup = DispatchGroup()
                    var products: [Product] = []
                    for queryDocumentSnapshot in querySnapshot!.documents {
                        dispatchGroup.enter()
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let company = data["company"] as? String ?? ""
                        let productDescription = data["productDescription"] as? String ?? ""
                        let category = data["category"] as? String ?? ""
                        let price = data["price"] as? Double ?? 0.0
                        let unitsSold = data["unitsSold"] as? Int ?? 0
                        let introducedForSale = data["introducedForSale"] as? Date ?? Date()
                        let isRecommended = data["isRecommended"] as? Bool ?? false
                        let isNew = data["isNew"] as? Bool ?? false
                        let keywords = data["keywords"] as? [String] ?? []
                        let imagesURLs = data["imagesURLs"] as? [String] ?? []
                        
                        if let languageCode = languageCode {
                            self.db
                                .collection(DatabaseCollections.products.rawValue)
                                .document(queryDocumentSnapshot.documentID)
                                .collection(DatabaseCollections.productSpecification.rawValue)
                                .document(languageCode)
                                .getDocument { documentSnapshot, error in
                                    if let error = error {
                                        print("Error fetching product specification: \(error.localizedDescription)")
                                        dispatchGroup.leave()
                                    } else {
                                        guard let specificationData = documentSnapshot?.data() else {
                                            dispatchGroup.leave()
                                            return
                                        }
                                        
                                        let productSpecification: ProductSpecification = [languageCode: [SpecificationKeys.processor: specificationData[SpecificationKeys.processor.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.ramMemory: specificationData[SpecificationKeys.ramMemory.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.massStorage: specificationData[SpecificationKeys.massStorage.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.displayType: specificationData[SpecificationKeys.displayType.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.displaySize: specificationData[SpecificationKeys.displaySize.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.displayResolution: specificationData[SpecificationKeys.displayResolution.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.pixelDensity: specificationData[SpecificationKeys.pixelDensity.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.refreshRate: specificationData[SpecificationKeys.refreshRate.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.displayBrightness: specificationData[SpecificationKeys.displayBrightness.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.cameraPhotoResolutionFront: specificationData[SpecificationKeys.cameraPhotoResolutionFront.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.cameraPhotoResolutionBack: specificationData[SpecificationKeys.cameraPhotoResolutionBack.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.cameraZoomBack: specificationData[SpecificationKeys.cameraZoomBack.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.cameraVideoResolutionBack: specificationData[SpecificationKeys.cameraVideoResolutionBack.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.connectivity: specificationData[SpecificationKeys.connectivity.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.inputs: specificationData[SpecificationKeys.inputs.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.fingerprintReader: specificationData[SpecificationKeys.fingerprintReader.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.faceReader: specificationData[SpecificationKeys.faceReader.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.operatingSystem: specificationData[SpecificationKeys.operatingSystem.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.weight: specificationData[SpecificationKeys.weight.decodeValue] as? String ?? "",
                                                                                                       SpecificationKeys.additionalInfo: specificationData[SpecificationKeys.additionalInfo.decodeValue] as? String ?? ""]]
                                        
                                        products.append(Product(id: id,
                                                                name: name,
                                                                company: company,
                                                                productDescription: productDescription,
                                                                category: Category.withLabel(category) ?? .other,
                                                                price: price,
                                                                specification: productSpecification,
                                                                unitsSold: unitsSold,
                                                                introducedForSale: introducedForSale,
                                                                isRecommended: isRecommended,
                                                                isNew: isNew,
                                                                keywords: keywords,
                                                                imagesURLs: imagesURLs))
                                        dispatchGroup.leave()
                                    }
                                }
                        } else {
                            products.append(Product(id: id,
                                                    name: name,
                                                    company: company,
                                                    productDescription: productDescription,
                                                    category: Category.withLabel(category) ?? .other,
                                                    price: price,
                                                    specification: [:],
                                                    unitsSold: unitsSold,
                                                    introducedForSale: introducedForSale,
                                                    isRecommended: isRecommended,
                                                    isNew: isNew,
                                                    keywords: keywords,
                                                    imagesURLs: imagesURLs))
                            
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        print("Successfully fetched products data")
                        completion(.success(products))
                    }
                }
            }
    }
    
    func getRatings(completion: @escaping ((Result<[ProductRating]?, Error>) -> ())) {
        db.collection(DatabaseCollections.productsRatings.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching all ratings data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let productRatings = querySnapshot!.documents.map { (queryDocumentSnapshot) -> ProductRating in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let productID = data["productID"] as? String ?? ""
                        let authorID = data["authorID"] as? String ?? ""
                        let authorFirstName = data["authorFirstName"] as? String ?? ""
                        let rating = data["rating"] as? Int ?? 0
                        let review = data["review"] as? String ?? ""
                        let date = data["date"] as? Date ?? Date()
                        
                        return ProductRating(id: id,
                                             productID: productID,
                                             authorID: authorID,
                                             authorFirstName: authorFirstName,
                                             rating: rating,
                                             review: review,
                                             date: date)
                    }
                    
                    print("Successfully fetched all ratings data")
                    completion(.success(productRatings))
                }
            }
    }
    
    func getProductRatings(productID: String, completion: @escaping ((Result<[ProductRating]?, Error>) -> ())) {
        db.collection(DatabaseCollections.productsRatings.rawValue)
            .whereField("productID", isEqualTo: productID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching product ratings data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let productRatings = querySnapshot!.documents.map { (queryDocumentSnapshot) -> ProductRating in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let productID = data["productID"] as? String ?? ""
                        let authorID = data["authorID"] as? String ?? ""
                        let authorFirstName = data["authorFirstName"] as? String ?? ""
                        let rating = data["rating"] as? Int ?? 0
                        let review = data["review"] as? String ?? ""
                        let date = data["date"] as? Date ?? Date()
                        
                        return ProductRating(id: id,
                                             productID: productID,
                                             authorID: authorID,
                                             authorFirstName: authorFirstName,
                                             rating: rating,
                                             review: review,
                                             date: date)
                    }
                    
                    print("Successfully fetched product ratings data")
                    completion(.success(productRatings))
                }
            }
    }
    
    func getDiscounts(completion: @escaping ((Result<[Discount]?, Error>) -> ())) {
        db.collection(DatabaseCollections.discounts.rawValue)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching discount data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let discounts = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Discount in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let productID = data["productID"] as? String ?? ""
                        let discountCode = data["discountCode"] as? String ?? ""
                        let discountValuePercent = data["discountValuePercent"] as? Double ?? 0.0
                        let redeemedByUsersIDs = data["redeemedByUsersIDs"] as? [String] ?? []
                        let redemptionNumber = data["redemptionNumber"] as? Int ?? 0
                        let maxRedemptionNumber = data["maxRedemptionNumber"] as? Int ?? 1
                        
                        return Discount(id: id,
                                        productID: productID,
                                        discountCode: discountCode,
                                        discountValuePercent: discountValuePercent,
                                        redeemedByUsersIDs: redeemedByUsersIDs,
                                        redemptionNumber: redemptionNumber,
                                        maxRedemptionNumber: maxRedemptionNumber)
                    }
                    
                    print("Successfully fetched discounts data")
                    completion(.success(discounts))
                }
            }
    }
    
    func getDiscountsFor(productID: String, completion: @escaping ((Result<[Discount]?, Error>) -> ())) {
        db.collection(DatabaseCollections.discounts.rawValue)
            .whereField("productID", isEqualTo: productID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching discounts for product data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let discounts = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Discount in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let productID = data["productID"] as? String ?? ""
                        let discountCode = data["discountCode"] as? String ?? ""
                        let discountValuePercent = data["discountValuePercent"] as? Double ?? 0.0
                        let redeemedByUsersIDs = data["redeemedByUsersIDs"] as? [String] ?? []
                        let redemptionNumber = data["redemptionNumber"] as? Int ?? 0
                        let maxRedemptionNumber = data["maxRedemptionNumber"] as? Int ?? 1
                        
                        return Discount(id: id,
                                        productID: productID,
                                        discountCode: discountCode,
                                        discountValuePercent: discountValuePercent,
                                        redeemedByUsersIDs: redeemedByUsersIDs,
                                        redemptionNumber: redemptionNumber,
                                        maxRedemptionNumber: maxRedemptionNumber)
                    }
                    
                    print("Successfully fetched discounts for product data")
                    completion(.success(discounts))
                }
            }
    }
    
    func getTrendingSearches(completion: @escaping ((Result<[String]?, Error>) -> ())) {
        db.collection(DatabaseCollections.trendingSearches.rawValue)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching trending searches: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let trendingSearches = querySnapshot!.documents.map { (queryDocumentSnapshot) -> String in
                        let data = queryDocumentSnapshot.data()

                        return data["searchValue"] as? String ?? ""
                    }
                    
                    print("Successfully fetched trending searches")
                    completion(.success(trendingSearches))
                }
            }
    }
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func addProduct(product: Product, completion: @escaping ((VoidResult) -> ())) {
        let productDocumentData: [String: Any] = [
            "id": product.id,
            "name": product.name,
            "company": product.company,
            "productDescription": product.productDescription,
            "category": product.category.decodeValue,
            "price": product.price,
            "unitsSold": product.unitsSold,
            "introducedForSale": product.introducedForSale,
            "isRecommended": product.isRecommended,
            "isNew": product.isNew,
            "keywords": product.keywords,
            "imagesURLs": product.imagesURLs,
        ]
        
        self.db.collection(DatabaseCollections.products.rawValue)
            .document(product.id)
            .setData(productDocumentData) { (error) in
            if let error = error {
                print("Error creating product's data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created product's data in database")
                completion(.success)
            }
        }
    }
    
    func addProductRating(productRating: ProductRating, completion: @escaping ((VoidResult) -> ())) {
        let productRatingDocumentData: [String: Any] = [
            "id": productRating.id,
            "productID": productRating.productID,
            "authorID": productRating.authorID,
            "authorFirstName": productRating.authorFirstName,
            "rating": productRating.rating,
            "review": productRating.review ?? "",
            "date": productRating.date
        ]
        
        self.db.collection(DatabaseCollections.productsRatings.rawValue)
            .document(productRating.id)
            .setData(productRatingDocumentData) { (error) in
            if let error = error {
                print("Error creating product's rating data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created product's rating data for user identifying with id: \(productRating.authorID) in database")
                completion(.success)
            }
        }
    }
    
    func addSpecificationForExistingProduct(productID: String, specification: ProductSpecification, completion: @escaping ((VoidResult) -> ())) {
        
    }
    
    func addDiscount(discount: Discount, completion: @escaping ((VoidResult) -> ())) {
        let discountDocumentData: [String: Any] = [
            "id": discount.id,
            "productID": discount.productID,
            "discountCode": discount.discountCode,
            "discountValuePercent": discount.discountValuePercent,
            "redeemedByUsersIDs": discount.redeemedByUsersIDs,
            "redemptionNumber": discount.redemptionNumber,
            "maxRedemptionNumber": discount.maxRedemptionNumber
        ]
        
        self.db.collection(DatabaseCollections.discounts.rawValue)
            .document(discount.id)
            .setData(discountDocumentData) { (error) in
            if let error = error {
                print("Error creating discount data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Successfully created discount data in database")
                completion(.success)
            }
        }
    }
    
    
    // MARK: UPDATE DATABASE OPERATIONS
    
    func redeemDiscount(userID: String, discount: Discount, completion: @escaping ((VoidResult) -> ())) {
        let updateData: [String: Any] = [
            "redeemedByUsersIDs": FieldValue.arrayUnion([userID]),
            "redemptionNumber": FieldValue.increment(Int64(1))
        ]
        
        self.db.collection(DatabaseCollections.discounts.rawValue)
            .document(discount.id)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error redeeming discount: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    documentSnapshot?.reference.updateData(updateData)
                    print("Successfully redeemed discount code \(discount.discountCode) by user \(userID)")
                    completion(.success)
                }
            }
    }
    
    func redeemDiscounts(userID: String, discounts: [Discount], completion: @escaping (() -> ())) {
        let group = DispatchGroup()
        
        for discount in discounts {
            group.enter()
            
            let updateData: [String: Any] = [
                "redeemedByUsersIDs": FieldValue.arrayUnion([userID]),
                "redemptionNumber": FieldValue.increment(Int64(1))
            ]
            
            self.db.collection(DatabaseCollections.discounts.rawValue)
                .document(discount.id)
                .getDocument { documentSnapshot, error in
                    if let error = error {
                        print("Error redeeming discount: \(error.localizedDescription)")
                    } else {
                        documentSnapshot?.reference.updateData(updateData)
                        print("Successfully redeemed discount code \(discount.discountCode) by user \(userID)")
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

extension FirestoreProductsManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
