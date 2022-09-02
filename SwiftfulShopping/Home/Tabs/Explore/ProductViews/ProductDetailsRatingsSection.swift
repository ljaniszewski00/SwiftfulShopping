//
//  ProductDetailsRatingsSection.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 05/08/2022.
//

import SwiftUI

struct ProductDetailsRatingsSection: View {
    @State private var ratingsSectionExpanded: Bool = true
    
    var product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    Text("Product Rating")
                        .font(.ssTitle2)
                        .padding(.horizontal)

                    HStack(spacing: 30) {
                        VStack(alignment: .center, spacing: 10) {
                            Text("\(product.rating.averageRating, specifier: "%.2f") / 5")
                                .font(.system(size: 26, weight: .bold))
                            HStack {
                                ForEach(1...Int(round(product.rating.averageRating)), id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.accentColor)
                                }

                                ForEach(Int(round(product.rating.averageRating))..<5, id: \.self) { _ in
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
                                            .frame(width: (130 / CGFloat(product.rating.ratingsNumber)),
                                                   height: 7)
                                    }
                                }
                            }

                            VStack(spacing: 5) {
                                ForEach(Array(1...5).reversed(), id: \.self) { number in
                                    Text("\(product.rating.productRates.filter { $0.rating == number }.count)")
                                        .font(.ssCallout)
                                        .foregroundColor(.ssDarkGray)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }

                VStack(alignment: .leading) {
                    Button(action: {
                        ratingsSectionExpanded.toggle()
                    }, label: {
                        HStack {
                            Text("Comments (\(product.rating.reviewsNumber))")
                                .font(.ssTitle3)
                                .padding(.leading)
                        }
                        Image(systemName: ratingsSectionExpanded ? "chevron.up" : "chevron.down")
                    })

                    if ratingsSectionExpanded {
                        VStack {
                            ForEach(Array(product.rating.productRates), id: \.self) { productRate in
                                if productRate.review != nil {
                                    HStack {
                                        HStack(spacing: 0) {
                                            

                                            VStack(alignment: .leading, spacing: 20) {
                                                HStack(spacing: 20) {
                                                    Image("blank_profile_image")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipShape(Circle())
                                                        .frame(width: 60, height: 60)
                                                    
                                                    VStack(alignment: .leading, spacing: 10) {
                                                        Text(productRate.authorFirstName)
                                                            .font(.ssTitle3)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        
                                                        HStack {
                                                            HStack(spacing: 5) {
                                                                Image(systemName: "star.fill")
                                                                    .resizable()
                                                                    .frame(width: 20, height: 20)
                                                                    .foregroundColor(.accentColor)
                                                                Text("\(productRate.rating)")
                                                                    .font(.ssCallout)
                                                            }

                                                            Text("•")
                                                                .padding(.horizontal, 5)

                                                            Text(productRate.date.dateString())
                                                                .font(.ssCallout)
                                                                .fixedSize(horizontal: true, vertical: false)
                                                        }
                                                    }
                                                }

                                                Text(productRate.review!)
                                                    .font(.ssBody).fontWeight(.regular)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .padding()
                                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                        }
                                    }
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
                ProductDetailsRatingsSection(product: Product.demoProducts[0])
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
