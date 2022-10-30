//
//  ProductRating.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/08/2022.
//

import Foundation

struct ProductRating {
    var id: String = ""
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
    static let demoProductsRatings: [ProductRating] = [ProductRating(id: "4S9nydoz5eZihDCjF4r0",
                                                                     productID: "LQHU7yJplIXugoPiLucR",
                                                                     authorID: "3buu4jX3Kg0HOLrOj00S",
                                                                     authorFirstName: "John",
                                                                     rating: 3,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "0pnjfdzilNI2UGdSzvsl",
                                                                     productID: "LQHU7yJplIXugoPiLucR",
                                                                     authorID: "gr8q6kQYU3wsmuaklTuv",
                                                                     authorFirstName: "Stacey",
                                                                     rating: 2,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "Mp6KExlj0szmFFMTinxX",
                                                                     productID: "LQHU7yJplIXugoPiLucR",
                                                                     authorID: "BndQZH4VngKoG462Pvb3",
                                                                     authorFirstName: "Simon",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       
                                                       /* */
                                                       
                                                       ProductRating(id: "6aUOS7UOfCuAdoMLB91e",
                                                                     productID: "mdQsy0eqYaSiKp6z393S",
                                                                     authorID: "yJ5eom6GyEm9ewjClsLx",
                                                                     authorFirstName: "Agnes",
                                                                     rating: 2,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "AdS140QDxg7sVcEJkvNk",
                                                                     productID: "mdQsy0eqYaSiKp6z393S",
                                                                     authorID: "gb0D72tt59D3oo1VnG8e",
                                                                     authorFirstName: "Matthew",
                                                                     rating: 3,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "Gd5ydCaDvqTsKXrofQVg",
                                                                     productID: "mdQsy0eqYaSiKp6z393S",
                                                                     authorID: "NLgSugZ1It5AKIWczocB",
                                                                     authorFirstName: "Angel",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       
                                                       /* */
                                                       
                                                       ProductRating(id: "evL1qV41ydzJ5h3LvDW9",
                                                                     productID: "BJll5oJjsBoq0tb6Ad8v",
                                                                     authorID: "xBy2wrxY1vPIoQnY5MqG",
                                                                     authorFirstName: "Nathalie",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "nS0saW66ttNsZ1lbLbck",
                                                                     productID: "BJll5oJjsBoq0tb6Ad8v",
                                                                     authorID: "tMRINNqtGKL3W7zoXr9V",
                                                                     authorFirstName: "Susan",
                                                                     rating: 1,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "1BldJzkqWN61dvjwRi5x",
                                                                     productID: "BJll5oJjsBoq0tb6Ad8v",
                                                                     authorID: "ylisUNtl1mMQd0Sn89Tk",
                                                                     authorFirstName: "Angel",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                
                                                       /* */
                                                       
                                                       ProductRating(id: "sprIVs6ABXxd21NNno34",
                                                                     productID: "v8yFH9voUUbMvYDXMX4o",
                                                                     authorID: "vgsYODzc91pLL0q08iO0",
                                                                     authorFirstName: "Nathalie",
                                                                     rating: 5,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "QYuqiY7wWLyMHBkKEAW2",
                                                                     productID: "v8yFH9voUUbMvYDXMX4o",
                                                                     authorID: "2PTCijylLkG9m3dEXjkd",
                                                                     authorFirstName: "Susan",
                                                                     rating: 3,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       ProductRating(id: "SXqA0GYEcBWNKrzfbL0s",
                                                                     productID: "v8yFH9voUUbMvYDXMX4o",
                                                                     authorID: "hXI456jxp6e1MmOMs4SN",
                                                                     authorFirstName: "Angel",
                                                                     rating: 2,
                                                                     review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
    
                                                       /* */
    
                                                    ProductRating(id: "sUR1wKmI0h0tmjMiNbF2",
                                                                  productID: "uMIJzBU5wcwwfUMqsJ2C",
                                                                  authorID: "mNue8POnPl1yNXqNEW9s",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 3,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "hgZivhE63Ad8GawyX0vP",
                                                                  productID: "uMIJzBU5wcwwfUMqsJ2C",
                                                                  authorID: "R7aoc2AfvadAEjULAatf",
                                                                  authorFirstName: "Susan",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "bzslzmSyvyAhTBL23dhG",
                                                                  productID: "uMIJzBU5wcwwfUMqsJ2C",
                                                                  authorID: "JBxrM6zCV9d2S9gP2auf",
                                                                  authorFirstName: "Angel",
                                                                  rating: 5,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    
                                                       /* */
                                                    
                                                    ProductRating(id: "xVJRSLQz1YKOgaojIw3e",
                                                                  productID: "IpD65nz0vKKgOUAzVDtq",
                                                                  authorID: "2WD1CFmCO33dH3KVpkJv",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 4,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "c4j8Wz9DmdQfVCYR8Fa8",
                                                                  productID: "IpD65nz0vKKgOUAzVDtq",
                                                                  authorID: "iI0xbyYyFbtYRN0Ky77J",
                                                                  authorFirstName: "Susan",
                                                                  rating: 1,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "ueIc7qYY6CWOvGaUnqPH",
                                                                  productID: "IpD65nz0vKKgOUAzVDtq",
                                                                  authorID: "Aa4OFzQZK9tzHNAl2cWd",
                                                                  authorFirstName: "Angel",
                                                                  rating: 4,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
    
                                                       /* */
    
                                                    ProductRating(id: "4AJUKNzP8egkMIzpH635",
                                                                  productID: "qxfRHQx4eQF748wBPN7B",
                                                                  authorID: "vzrXAAiu6WDeSRoXiHm1",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "AV0jVoJaecAU2gIPuIJr",
                                                                  productID: "qxfRHQx4eQF748wBPN7B",
                                                                  authorID: "1fYOYFij08XClFEXzPzH",
                                                                  authorFirstName: "Susan",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "XgLAaD6i3xVXV4Ky9uDL",
                                                                  productID: "qxfRHQx4eQF748wBPN7B",
                                                                  authorID: "Jsb8yKxzfluQ6BprwBjs",
                                                                  authorFirstName: "Angel",
                                                                  rating: 5,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    
                                                       /* */
                                                    
                                                    ProductRating(id: "VhS3SExHSdwIjgGS3Rqz",
                                                                  productID: "veArtsZlHvLVmJgB1Eb2",
                                                                  authorID: "A1vAZ0unPXH5crSw4yBr",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 1,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "lBh8JzaLWI0TJOy9Tf88",
                                                                  productID: "veArtsZlHvLVmJgB1Eb2",
                                                                  authorID: "rr3y7BfRIJ5R2vPRjcfH",
                                                                  authorFirstName: "Susan",
                                                                  rating: 5,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "uD1zSb4WyrCW1O5uMvKu",
                                                                  productID: "veArtsZlHvLVmJgB1Eb2",
                                                                  authorID: "8YwITiFahOlHgC5H0KoG",
                                                                  authorFirstName: "Angel",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    
                                                       /* */
                                                    
                                                    ProductRating(id: "LW894QM6CDSsZvS154ne",
                                                                  productID: "7vHPvsjhC2N3DszzpejX",
                                                                  authorID: "WiaTqC1Jhvjsfuv0EnUo",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 1,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "0iuuOYkCHdXDJpoJlJuB",
                                                                  productID: "7vHPvsjhC2N3DszzpejX",
                                                                  authorID: "ZOs2bUwQuo0a2kQczr7o",
                                                                  authorFirstName: "Susan",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "uerZ6Uz09GGMPPkCspPg",
                                                                  productID: "7vHPvsjhC2N3DszzpejX",
                                                                  authorID: "ZMfNo7pyeahdCP8SUn6j",
                                                                  authorFirstName: "Angel",
                                                                  rating: 3,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    
                                                       /* */
                                                    
                                                    ProductRating(id: "NPqHzxLJVzm0i80eaFGh",
                                                                  productID: "K3UWdDrCQD6fVJgJk6dX",
                                                                  authorID: "JQR8zBvtGjCY6lrsIoqp",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 4,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "kXwb62LKOPZoIh4n3Gd0",
                                                                  productID: "K3UWdDrCQD6fVJgJk6dX",
                                                                  authorID: "3WOz7aguAbSEgGzdeo1F",
                                                                  authorFirstName: "Susan",
                                                                  rating: 3,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "TOBjwLsEuXu1OaMpHQdM",
                                                                  productID: "K3UWdDrCQD6fVJgJk6dX",
                                                                  authorID: "r6jyuYVPtNdiGxH4aMJE",
                                                                  authorFirstName: "Angel",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                       
                                                       /* */
                                                    
                                                    ProductRating(id: "7wiLZsIprEpZlaB8NDdH",
                                                                  productID: "cKuK5oxw6WaHWaMmxkyW",
                                                                  authorID: "Ih9mVFd3rqrLocEyU3QP",
                                                                  authorFirstName: "Nathalie",
                                                                  rating: 3,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "1N02QUUAqFtJrTpsXXpM",
                                                                  productID: "cKuK5oxw6WaHWaMmxkyW",
                                                                  authorID: "jKIkznK1HmHqCz8bPfnY",
                                                                  authorFirstName: "Susan",
                                                                  rating: 5,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede."),
                                                    ProductRating(id: "pRVWc3AuDVhVNp4sH7Pn",
                                                                  productID: "cKuK5oxw6WaHWaMmxkyW",
                                                                  authorID: "PGAyylYaQ728dhuqGpgS",
                                                                  authorFirstName: "Angel",
                                                                  rating: 2,
                                                                  review: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.")]
}
