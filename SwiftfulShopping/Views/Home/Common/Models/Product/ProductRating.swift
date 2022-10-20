//
//  ProductRating.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/08/2022.
//

import Foundation

struct ProductRating {
    var id: String = UUID().uuidString
    var productID: String
    var authorID: String
    var authorFirstName: String
    var rating: Int
    var review: String?
    var date: Date = Date()
}

extension ProductRating: Equatable, Hashable {
    static func == (lhs: ProductRating, rhs: ProductRating) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ProductRating {
    static let demoProductsRatings: [ProductRating] = [ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "John",
                                                                     rating: 3,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Stacey",
                                                                     rating: 2,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Simon",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Agnes",
                                                                     rating: 2,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Matthew",
                                                                     rating: 3,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Angel",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Nathalie",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(productID: Product.demoProducts[0].id,
                                                                     authorID: UUID().uuidString,
                                                                     authorFirstName: "Susan",
                                                                     rating: 1,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.")]
}
