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
    
    func getProducts(userID: String, completion: @escaping (([Product]?) -> ())) {
        db.collection(DatabaseCollections.products.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching products data: \(error.localizedDescription)")
                } else {
                    let products = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Product in
                        
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
                        let rating = data["rating"] as? String ?? ""
                        let imagesURLs = data["imagesURLs"] as? [String] ?? []
                        
                        return Product(id: id,
                                       name: name,
                                       company: company,
                                       productDescription: productDescription,
                                       category: Category.withLabel(category) ?? .other,
                                       price: price,
                                       unitsSold: unitsSold,
                                       introducedForSale: introducedForSale,
                                       isRecommended: isRecommended,
                                       isNew: isNew,
                                       keywords: keywords,
                                       imagesURLs: imagesURLs)
                    }
                    
                    print("Successfully fetched products data")
                    
                    completion(products)
                }
            }
    }
    
    func getProductRatings(productID: String, completion: @escaping ((ProductRating?) -> ())) {
        db.collection(DatabaseCollections.productsRatings.rawValue)
            .document(productID)
            .collection(DatabaseCollections.productRates.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching product rates data: \(error.localizedDescription)")
                } else {
                    let productRates = querySnapshot!.documents.map { (queryDocumentSnapshot) -> ProductRate in
                        
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let authorID = data["authorID"] as? String ?? ""
                        let authorFirstName = data["authorFirstName"] as? String ?? ""
                        let rating = data["rating"] as? Int ?? 0
                        let review = data["review"] as? String ?? ""
                        let date = data["date"] as? Date ?? Date()
                        
                        return ProductRate(id: id,
                                           authorID: authorID,
                                           authorFirstName: authorFirstName,
                                           rating: rating,
                                           review: review,
                                           date: date)
                    }
                    
                    print("Successfully fetched product ratings data")
                    
                    let productRating = ProductRating(id: productID,
                                                      productRates: productRates)
                    
                    completion(productRating)
                }
            }
    }
    
    func getDiscounts(productID: String, completion: @escaping (([Discount]?) -> ())) {
        db.collection(DatabaseCollections.discounts.rawValue)
            .whereField("productID", isEqualTo: productID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching discount data: \(error.localizedDescription)")
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
                    
                    completion(discounts)
                }
            }
    }
    
    
    // MARK: INSERT DATABASE OPERATIONS
    
    func addProductRate(userID: String, productRate: ProductRate, completion: @escaping ((Bool, Error?) -> ())) {
        let productRatingDocumentData: [String: Any] = [
            "id": productRate.productID
        ]
        
        self.db.collection(DatabaseCollections.productsRatings.rawValue)
            .document(productRate.productID)
            .setData(productRatingDocumentData) { (error) in
            if let error = error {
                print("Error creating product's rating data: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully created product's rating data for user identifying with id: \(userID) in database")
                let productRateDocumentData: [String: Any] = [
                    "id": productRate.id,
                    "authorID": productRate.authorID,
                    "authorFirstName": productRate.authorFirstName,
                    "rating": productRate.rating,
                    "review": productRate.review ?? "",
                    "date": productRate.date
                ]
                
                self.db.collection(DatabaseCollections.productsRatings.rawValue)
                    .document(productRate.productID)
                    .collection(DatabaseCollections.productRates.rawValue)
                    .document(productRate.id)
                    .setData(productRateDocumentData)
                    
                completion(true, nil)
            }
        }
    }
    
    func redeemDiscount(userID: String, discount: Discount, completion: @escaping (([Discount]?) -> ())) {
        let updatedDiscountDocumentData: [String: Any] = [
            "redeemedByUsersIDs": FieldValue.arrayUnion([userID]),
            "redemptionNumber": FieldValue.increment(Int64(1))
        ]
        
        db.collection(DatabaseCollections.discounts.rawValue)
            .document(discount.id)
            .updateData(updatedDiscountDocumentData)
    }
}

extension FirestoreProductsManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
