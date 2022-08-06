//
//  ProductRating.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/08/2022.
//

import Foundation

struct ProductRating {
    var id: String = UUID().uuidString
    var productRates: [ProductRate]
    
    var averageRating: Double {
        var overallRating: Int = 0
        for productRate in productRates {
            overallRating += productRate.rating
        }
        return Double(overallRating / productRates.count)
    }
    var ratingsNumber: Int {
        productRates.count
    }
    var reviewsNumber: Int {
        var count: Int = 0
        for productRate in productRates {
            if productRate.review != nil {
                count += 1
            }
        }
        return count
    }
}

extension ProductRating: Equatable, Hashable {
    static func == (lhs: ProductRating, rhs: ProductRating) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ProductRate {
    var id: String = UUID().uuidString
    var authorID: String
    var authorFirstName: String
    var rating: Int
    var review: String?
    var date: Date = Date()
}

extension ProductRate: Equatable, Hashable {
    static func == (lhs: ProductRate, rhs: ProductRate) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ProductRating {
    static let demoProductsRatings: [ProductRating] = [ProductRating(productRates: [ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "John",
                                                                                                rating: 3,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,                  authorFirstName: "Stacey",
                                                                                                rating: 2,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "Simon",
                                                                                                rating: 5,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "Agnes",
                                                                                                rating: 2,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "Matthew",
                                                                                                rating: 3,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "Angel",
                                                                                                rating: 5,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "Nathalie",
                                                                                                rating: 5,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                                                    ProductRate(authorID: UUID().uuidString,
                                                                                                authorFirstName: "Susan",
                                                                                                rating: 1,
                                                                                                review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.")])]
}
