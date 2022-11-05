//
//  ProductDetailsRatingsSection.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 05/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ProductDetailsRatingsSection: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var ratingsSectionExpanded: Bool = true
    
    var product: Product
    var productRatings: [ProductRating]
    
    var averageRating: Double {
        if productRatings.isEmpty {
            return 0
        } else {
            return Double(productRatings.reduce(0, { $0 + $1.rating })) / Double(productRatings.count)
        }
    }
    
    var reviewsNumber: Int {
        productRatings.filter { $0.review != nil }.count
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    Text(TexterifyManager.localisedString(key: .productDetailsRatingsSection(.productRating)))
                        .font(.ssTitle2)

                    HStack(spacing: 30) {
                        VStack(alignment: .center, spacing: 10) {
                            Text("\(averageRating, specifier: "%.2f") / 5")
                                .font(.system(size: 26, weight: .bold))
                            HStack {
                                if averageRating != 0 {
                                    ForEach(1...Int(floor(averageRating)), id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.accentColor)
                                    }
                                }

                                ForEach(Int(floor(averageRating))..<5, id: \.self) { _ in
                                    Image(systemName: "star")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }

                        HStack {
                            VStack(spacing: 5) {
                                ForEach(Array(1...5).reversed(), id: \.self) { number in
                                    Text("\(number)")
                                        .font(.ssCallout)
                                }
                            }

                            VStack(spacing: 5) {
                                ForEach(1...5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.accentColor)
                                }
                            }

                            VStack(spacing: 18) {
                                ForEach(Array(1...5).reversed(), id: \.self) { number in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.ssGray)
                                            .frame(width: 130, height: 7)
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.accentColor)
                                            .frame(width: productRatings.filter { $0.rating == number }.count == 0 ? 0 : CGFloat((130 / productRatings.count) * (productRatings.filter { $0.rating == number }.count)),
                                                   height: 7)
                                    }
                                }
                            }

                            VStack(spacing: 5) {
                                ForEach(Array(1...5).reversed(), id: \.self) { number in
                                    Text("\(productRatings.filter { $0.rating == number }.count)")
                                        .font(.ssCallout)
                                        .foregroundColor(.ssDarkGray)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }

                VStack(alignment: .leading) {
                    Button(action: {
                        ratingsSectionExpanded.toggle()
                    }, label: {
                        HStack {
                            Text("\(TexterifyManager.localisedString(key: .productDetailsRatingsSection(.comments))) (\(reviewsNumber))")
                                .font(.ssTitle3)
                                .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        }
                        Image(systemName: ratingsSectionExpanded ? "chevron.up" : "chevron.down")
                    })

                    if ratingsSectionExpanded {
                        VStack {
                            ForEach(Array(productRatings), id: \.self) { productRating in
                                if let productReview = productRating.review {
                                    VStack(alignment: .leading, spacing: 20) {
                                        HStack(spacing: 20) {
                                            Image(AssetsNames.blankProfile)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 60, height: 60)
                                            
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text(productRating.authorFirstName)
                                                    .font(.ssTitle3)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                HStack {
                                                    HStack(spacing: 5) {
                                                        Image(systemName: "star.fill")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.accentColor)
                                                        Text("\(productRating.rating)")
                                                            .font(.ssCallout)
                                                    }

                                                    Text("•")
                                                        .padding(.horizontal, 5)

                                                    Text(productRating.date.dateString())
                                                        .font(.ssCallout)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                }
                                            }
                                            
                                            Spacer()
                                        }

                                        Text(productReview)
                                            .font(.ssBody).fontWeight(.regular)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial,
                                                in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct ProductDetailsRatingsSection_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductDetailsRatingsSection(product: Product.demoProducts[0],
                                             productRatings: ProductRating.demoProductsRatings)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
