//
//  Product.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Product {
    var id: String = UUID().uuidString
    var name: String
    var company: String
    var productDescription: String
    var category: Category = .other
    var price: Double
    var unitsSold: Int = 0
    var introducedForSale: Date = Date()
    var isRecommended = false
    var ratings: [Int: [String]] = [1: [], 2: [], 3: [], 4: [], 5: []]
    var reviews: [String: String] = [:]
    var imageURL: String = "https://res.cloudinary.com/drqqwwpen/image/upload/v1596474380/pcs/not-available_g2vsum.jpg"
}

extension Product: Equatable, Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Product: CustomStringConvertible {
    var description: String {
        "\(id)\n\(name)\n\(company)\n\(productDescription)\n\(price)"
    }
}

extension Product {
    static let demoProducts: [Product] = [Product(id: "11111111111111111",
                                                  name: "iPhone 12",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 1",
                                                  category: .phones,
                                                  price: 20.15,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]],
                                                  reviews: [UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.",
                                                            UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."],
                                                  imageURL: "https://img.poorvika.com/cdn-cgi/image/width=400,height=400,quality=75/1600_JPG/Mobiles/Apple/Apple-iPhone-13-New/Apple-iPhone-13-starlight-front-back.jpg"),
                                          Product(id: "222222222222222",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .phones,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]],
                                                  reviews: [UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.",
                                                            UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."]),
                                          Product(id: "33333333333333333",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .tablets,
                                                  price: 10.15,
                                                  unitsSold: 10,
                                                  isRecommended: true,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]],
                                                  reviews: [UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.",
                                                            UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."]),
                                          Product(id: "444444444444444",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .tablets,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]],
                                                  reviews: [UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.",
                                                            UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."]),
                                          Product(id: "55555555555555",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .laptops,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]],
                                                  reviews: [UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.",
                                                            UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."]),
                                          Product(id: "6666666666666",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .watches,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]],
                                                  reviews: [UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.",
                                                            UUID().uuidString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."]),
                                          Product(id: "77777777777777",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]]),
                                          Product(id: "88888888888888",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]]),
                                          Product(id: "99999999999999",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]]),
                                          Product(id: "000000000000000",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .other,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]]),
                                          Product(id: "1010101010101010",
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .other,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  ratings: [1: [UUID().uuidString, UUID().uuidString],
                                                            2: [UUID().uuidString, UUID().uuidString],
                                                            3: [UUID().uuidString, UUID().uuidString],
                                                            4: [UUID().uuidString, UUID().uuidString],
                                                            5: [UUID().uuidString, UUID().uuidString]])]
    
    mutating func addRating(userID: String, rating: Int, review: String?) {
        if ratings[rating] != nil {
            ratings[rating]!.append(userID)
        }
        
        if let review = review {
            reviews[userID] = review
        }
    }
}
