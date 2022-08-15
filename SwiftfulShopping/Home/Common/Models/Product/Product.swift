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
    var category: Category
    var price: Double
    var unitsSold: Int = 0
    var introducedForSale: Date = Date()
    var isRecommended: Bool = false
    var rating: ProductRating
    var imagesURLs: [String] = ["https://res.cloudinary.com/drqqwwpen/image/upload/v1596474380/pcs/not-available_g2vsum.jpg"]
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
                                                  price: 20.15,
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
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  isRecommended: true,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/ipad-air-select-wifi-blue-202203?wid=940&hei=1112&fmt=png-alpha&.v=1645065732688",
                                                               "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/ipad-air-select-wifi-starlight-202203?wid=1765&hei=2000&fmt=jpeg&qlt=95&.v=1645895139236"]),
                                          Product(id: "33333333333333333",
                                                  name: "iPad Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "The ultimate iPad experience. Now with breakthrough M1 performance, a breathtaking XDR display, and blazing‑fast 5G wireless. Buckle up.",
                                                  category: .tablets,
                                                  price: 10.15,
                                                  unitsSold: 10,
                                                  isRecommended: true,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/refurb-ipad-pro-12-cell-silver-2020_AV1?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1626721060000", "https://www.mediaexpert.pl/media/cache/resolve/gallery/images/29/2958690/iPad-Pro-12.9-Cellular-01.jpg"]),
                                          Product(id: "444444444444444",
                                                  name: "MacBook Air",
                                                  company: "Apple Inc.",
                                                  productDescription: "There’s power in silence. Thanks to the efficiency of the M2 chip, MacBook Air can deliver amazing performance without a fan — so it stays completely silent no matter how intense the task.",
                                                  category: .laptops,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-air-space-gray-config-201810?wid=1078&hei=624&fmt=jpeg&qlt=90&.v=1633033424000", "https://www.mediaexpert.pl/media/cache/resolve/gallery/images/22/2291770/APPLE-MacBook-Air-front.jpg"]),
                                          Product(id: "55555555555555",
                                                  name: "MacBook Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "The most powerful MacBook Pro ever is here. With the blazing-fast M1 Pro or M1 Max chip — the first Apple silicon designed for pros — you get groundbreaking performance and amazing battery life. Add to that a stunning Liquid Retina XDR display, the best camera and audio ever in a Mac notebook, and all the ports you need. The first notebook of its kind, this MacBook Pro is a beast.",
                                                  category: .laptops,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/mbp14-spacegray-select-202110_GEO_PL?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1633657362000", "https://idream.pl/images/detailed/64/Pro_14''_silver_-_2-21_au0y-ri.png"]),
                                          Product(id: "6666666666666",
                                                  name: "iMac",
                                                  company: "Apple Inc.",
                                                  productDescription: "Say hello to the new iMac. Inspired by the best of Apple. Transformed by the M1 chip. Stands out in any space. Fits perfectly into your life.",
                                                  category: .computers,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://www.apple.com/euro/imac-24/c/screens_alt/images/meta/imac-24_why-mac__bocz4nf55sc2_og.png", "https://ispot.pl/img/imagecache/64001-65000/680x614/product-media/64001-65000/Apple-iMac-24-z-ekranem-Retina-4-5K-procesor-Apple-M1-8-rdzeniowy-procesor-i-8-rdzeniowa-grafika-dysk-256-GB-zielony-18094-680x614-nobckgr.webp"]),
                                          Product(id: "77777777777777",
                                                  name: "Mac Pro",
                                                  company: "Apple Inc.",
                                                  productDescription: "Power to change everything. Say hello to a Mac that is extreme in every way. With the greatest performance, expansion, and configurability yet, it is a system created to let a wide range of professionals push the limits of what is possible.",
                                                  category: .computers,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2019/12/pr_2019_12_29_18_38_38_261_02.jpg", "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/mac-pro-hero-cto_FMT_WHH?wid=366&hei=430&fmt=jpeg&qlt=90&.v=1572288819522"]),
                                          Product(id: "77777777777777",
                                                  name: "Apple Watch Series 7",
                                                  company: "Apple Inc.",
                                                  productDescription: "The larger display enhances the entire experience, making Apple Watch easier to use and read. Series 7 represents our biggest and brightest thinking.",
                                                  category: .watches,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MKUE3_VW_34FR+watch-41-alum-blue-nc-7s_VW_34FR_WF_CO?wid=1400&hei=1400&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1632171048000%2C1631661090000", "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MKUQ3_VW_PF+watch-45-alum-midnight-nc-7s_VW_PF_WF_CO?wid=1400&hei=1400&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1632171068000%2C1631661680000"]),
                                          Product(id: "77777777777777",
                                                  name: "AirPods Pro",
                                                  company: "US TOT LTD.",
                                                  productDescription: "AirPods Pro are the only in-ear headphones with Active Noise Cancellation that continuously adapts to the geometry of your ear and the fit of the ear tips — blocking out the world so you can focus on what you’re listening to.",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MWP22?wid=2000&hei=2000&fmt=jpeg&qlt=95&.v=1591634795000", "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MWP22_AV2?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1591634643000"]),
                                          Product(id: "77777777777777",
                                                  name: "AirPods Max",
                                                  company: "Apple Inc.",
                                                  productDescription: "Introducing AirPods Max — a perfect balance of exhilarating high-fidelity audio and the effortless magic of AirPods. The ultimate personal listening experience is here.",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/airpods-max-hero-select-202011_FMT_WHH?wid=607&hei=556&fmt=jpeg&qlt=90&.v=1633623988000", "https://www.mediaexpert.pl/media/cache/resolve/gallery/images/26/2684553/Sluchawki-nauszne-APPLE-Airpods-Max-Gwiezdna-szarosc-02.jpg"]),
                                          Product(id: "77777777777777",
                                                  name: "Apple TV 4K",
                                                  company: "Apple Inc.",
                                                  productDescription: "Apple TV 4K brings the best of TV together with your favorite Apple devices and services — in a powerful experience that will transform your living room.",
                                                  category: .accessories,
                                                  price: 10.15,
                                                  unitsSold: 100,
                                                  rating: ProductRating.demoProductsRatings[0],
                                                  imagesURLs: ["https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/apple-tv-4k-hero-select-202104_FMT_WHH?wid=640&hei=600&fmt=jpeg&qlt=90&.v=1617137945000", "https://image.ceneostatic.pl/data/article_picture/be/54/550e-e91f-4e61-a244-3f844fe58705_large.jpg"])]
    
    mutating func addRate(authorID: String, authorFirstName: String, rating: Int, review: String?) {
        self.rating.productRates.append(ProductRate(authorID: authorID, authorFirstName: authorFirstName, rating: rating, review: review))
    }
}
