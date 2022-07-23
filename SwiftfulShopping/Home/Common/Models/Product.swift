//
//  Product.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/06/2022.
//

import Foundation

struct Product {
    var id: String
    var name: String
    var company: String
    var productDescription: String
    var category: Category = .other
    var price: Double
    var unitsSold: Int = 0
    var introducedForSale: Date = Date()
    var isRecommended = false
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
    static let demoProducts: [Product] = [Product(id: UUID().uuidString,
                                                  name: "iPhone 12",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 1",
                                                  category: .phones,
                                                  price: 20.15,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  imageURL: "https://img.poorvika.com/cdn-cgi/image/width=400,height=400,quality=75/1600_JPG/Mobiles/Apple/Apple-iPhone-13-New/Apple-iPhone-13-starlight-front-back.jpg"),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .phones,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  isRecommended: true),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .tablets,
                                                  price: 10.15,
                                                  unitsSold: 10,
                                                  isRecommended: true),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .tablets,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .laptops,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .watches,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .other,
                                                  price: 10.15,
                                                  unitsSold: 100),
                                          Product(id: UUID().uuidString,
                                                  name: "Product 2",
                                                  company: "US TOT LTD.",
                                                  productDescription: "This is the standard description of product 2",
                                                  category: .other,
                                                  price: 10.15,
                                                  unitsSold: 100)]
}
