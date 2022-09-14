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
    var category: Category
    var price: Double
    var unitsSold: Int
    var introducedForSale: Date
    var isRecommended: Bool
    var isNew: Bool
    var keywords: [String]
    var rating: ProductRating
    var imagesURLs: [String]
    
    init(id: String = UUID().uuidString,
         name: String,
         company: String,
         productDescription: String,
         category: Category,
         price: Double,
         unitsSold: Int = 0,
         introducedForSale: Date = Date(),
         isRecommended: Bool = false,
         isNew: Bool = true,
         keywords: [String] = [],
         rating: ProductRating,
         imagesURLs: [String] = ["https://res.cloudinary.com/drqqwwpen/image/upload/v1596474380/pcs/not-available_g2vsum.jpg"]) {
        self.id = id
        self.name = name
        self.company = company
        self.productDescription = productDescription
        self.category = category
        self.price = price
        self.unitsSold = unitsSold
        self.introducedForSale = introducedForSale
        self.isRecommended = isRecommended
        self.isNew = isNew
        if keywords.isEmpty {
            self.keywords = [name, company, productDescription]
        } else {
            self.keywords = keywords
        }
        self.rating = rating
        self.imagesURLs = imagesURLs
    }
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
                                                  name: "iPhone 13 Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "iPhone 13 Pro takes a huge leap forward, bringing incredible speed to everything you do and dramatic new photo and video capabilities — all in two great sizes.",
                                                  category: .phones,
                                                  price: 799.99,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-green-select?wid=940&hei=1112&fmt=png-alpha&.v=1644969385495",
                                                               "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-silver-select?wid=940&hei=1112&fmt=png-alpha&.v=1645552346280"]),
                                          Product(id: "222222222222222",
                                                  name: "iPad Air",
                                                  company: "Apple Inc.",
                                                  productDescription: "iPad Air lets you immerse yourself in whatever you’re reading, watching, or creating. The 10.9-inch Liquid Retina display features advanced technologies like True Tone, P3 wide color, and an antireflective coating.1",
                                                  category: .tablets,
                                                  price: 599.99,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://mac-shop.pl/environment/cache/images/500_500_productGfx_14857.webp",
                                                               "https://www.orange.pl/medias/sys_master/root/images/h51/h41/11348699611166/ipad-air-5g-spacegray-front-OraProductZoom.png"]),
                                          Product(id: "33333333333333333",
                                                  name: "iPad Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "The ultimate iPad experience. Now with breakthrough M1 performance, a breathtaking XDR display, and blazing‑fast 5G wireless. Buckle up.",
                                                  category: .tablets,
                                                  price: 899.99,
                                                  unitsSold: 10,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://www.orange.pl/medias/sys_master/root/images/hfa/h0a/9792549683230/ipad-pro-11-space-gray-front-OraProductZoom.png",
                                                               "https://toppng.com/uploads/preview/starting-at-ipad-pro-105-11569058975xz9kcmjfqn.png"]),
                                          Product(id: "444444444444444",
                                                  name: "MacBook Air",
                                                  company: "Apple Inc.",
                                                  productDescription: "There’s power in silence. Thanks to the efficiency of the M2 chip, MacBook Air can deliver amazing performance without a fan — so it stays completely silent no matter how intense the task.",
                                                  category: .laptops,
                                                  price: 999.99,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP825/macbookair.png",
                                                               "https://static.api.plenti.app/file/product/2900"]),
                                          Product(id: "55555555555555",
                                                  name: "MacBook Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "The most powerful MacBook Pro ever is here. With the blazing-fast M1 Pro or M1 Max chip — the first Apple silicon designed for pros — you get groundbreaking performance and amazing battery life. Add to that a stunning Liquid Retina XDR display, the best camera and audio ever in a Mac notebook, and all the ports you need. The first notebook of its kind, this MacBook Pro is a beast.",
                                                  category: .laptops,
                                                  price: 1399.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://w7.pngwing.com/pngs/279/698/png-transparent-macbookpro-apple-material-apple-macbook-pro-computer-product-in-kind.png",
                                                               "https://toppng.com/uploads/preview/macbook-pro-with-touch-bar-11562986819zyl2ty8n0m.png"]),
                                          Product(id: "6666666666666",
                                                  name: "iMac",
                                                  company: "Apple Inc.",
                                                  productDescription: "Say hello to the new iMac. Inspired by the best of Apple. Transformed by the M1 chip. Stands out in any space. Fits perfectly into your life.",
                                                  category: .computers,
                                                  price: 1599.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://images.macrumors.com/t/ylfMwnTtxo7SQpK6767ULmfZarY=/1600x1200/smart/article-new/2013/09/imac-m1-blue-isolated-16x9-500k.png",
                                                               "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/M1_iMac_vector.svg/1200px-M1_iMac_vector.svg.png"]),
                                          Product(id: "77777777777777",
                                                  name: "Mac Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "Power to change everything. Say hello to a Mac that is extreme in every way. With the greatest performance, expansion, and configurability yet, it is a system created to let a wide range of professionals push the limits of what is possible.",
                                                  category: .computers,
                                                  price: 2599.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://imagazine.pl/wp-content/uploads/2019/06/Mac-Pro-2019-mid-and-Pro-Display-XDR-10.png",
                                                               "https://macmedic.com.au/wp-content/uploads/2021/07/MacMedic-Sydney-Mac_Pro_2-up_Screen__USEN.png"]),
                                          Product(id: "88888888888888",
                                                  name: "Apple Watch Series 7",
                                                  company: "Apple Inc.",
                                                  productDescription: "The larger display enhances the entire experience, making Apple Watch easier to use and read. Series 7 represents our biggest and brightest thinking.",
                                                  category: .watches,
                                                  price: 499.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MN2D3_VW_PF+watch-45-alum-starlight-cell-7s_VW_PF_WF_SI?wid=2000&hei=2000&fmt=png-alpha&.v=1645128285436,1631661830000",
                                                       "https://cdn.shopify.com/s/files/1/0613/5683/5009/products/series7-480_grande.png?v=1653135860"]),
                                          Product(id: "999999999999999",
                                                  name: "AirPods Pro",
                                                  company: "US TOT LTD.",
                                                  productDescription: "AirPods Pro are the only in-ear headphones with Active Noise Cancellation that continuously adapts to the geometry of your ear and the fit of the ear tips — blocking out the world so you can focus on what you’re listening to.",
                                                  category: .accessories,
                                                  price: 249.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://www.freepnglogos.com/uploads/airpods-png/airpods-apple-news-articles-stories-trends-for-today-14.png",
                                                               "https://i.pinimg.com/originals/cf/8a/5e/cf8a5e66b8641f3b1b11e364e84fb093.png"]),
                                          Product(id: "101010101010101010",
                                                  name: "AirPods Max",
                                                  company: "Apple Inc.",
                                                  productDescription: "Introducing AirPods Max — a perfect balance of exhilarating high-fidelity audio and the effortless magic of AirPods. The ultimate personal listening experience is here.",
                                                  category: .accessories,
                                                  price: 499.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://www.apple.com/v/airpods-max/e/images/overview/hero__gnfk5g59t0qe_xlarge.png",
                                                               "https://www.apple.com/v/airpods-max/e/images/overview/design_hero_cups__ddp0h9jo76gm_large.png"]),
                                          Product(id: "111111111111111111111111",
                                                  name: "Apple TV 4K",
                                                  company: "Apple Inc.",
                                                  productDescription: "Apple TV 4K brings the best of TV together with your favorite Apple devices and services — in a powerful experience that will transform your living room.",
                                                  category: .accessories,
                                                  price: 399.99,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://w7.pngwing.com/pngs/326/890/png-transparent-apple-tv-4k-apple-tv-4th-generation-4k-resolution-new-autumn-products-television-electronics-media-player-thumbnail.png",
                                                               "https://w7.pngwing.com/pngs/393/564/png-transparent-apple-tv-4th-generation-television-apple-tv-4k-creative-certificate-material-television-electronics-electronic-device-thumbnail.png"])]
    
    mutating func addRate(authorID: String, authorFirstName: String, rating: Int, review: String?) {
        self.rating.productRates.append(ProductRate(authorID: authorID, authorFirstName: authorFirstName, rating: rating, review: review))
    }
}
