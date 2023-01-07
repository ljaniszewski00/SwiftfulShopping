//
//  DatabaseTable.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 24/09/2022.
//

import Foundation

enum DatabaseCollections: String {
    
    // MARK: - -  For FirestoreAuthenticationManager and FirestoreProfileManager
    case profiles = "Profiles"
    case shipmentAddresses = "Shipment Addresses"
    case invoiceAddresses = "Invoice Addresses"
    
    // MARK: - -  For FirestoreOrdersManager
    case orders = "Orders"
    
    // MARK: - -  For FirestoreReturnsManager
    case returns = "Returns"
    
    // MARK: - -  For FirestoreProductsManager
    case discounts = "Discounts"
    case products = "Products"
    case productSpecification = "Specification"
    case productsRatings = "Products Ratings"
    case trendingSearches = "Trending Searches"
}
