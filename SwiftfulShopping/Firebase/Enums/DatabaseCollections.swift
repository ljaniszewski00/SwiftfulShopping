//
//  DatabaseTable.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 24/09/2022.
//

import Foundation

enum DatabaseCollections: String {
    
    // MARK: For FirestoreAuthenticationManager and FirestoreProfileManager
    case profiles = "Profiles"
    case shipmentAddresses = "Shipment Addresses"
    case invoiceAddresses = "Invoice Addresses"
    
    // MARK: For FirestoreOrdersManager
    case carts = "Carts"
    case orders = "Orders"
    
    // MARK: For FirestoreReturnsManager
    case returns = "Returns"
    
    // MARK: For FirestoreProductsManager
    case discounts = "Discounts"
    case products = "Products"
    case productsRatings = "Products Ratings"
    case productRates = "Product Rates"
}
