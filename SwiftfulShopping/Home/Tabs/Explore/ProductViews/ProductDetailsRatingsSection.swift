//
//  ProductDetailsRatingsSection.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 03/08/2022.
//

import SwiftUI

struct ProductDetailsRatingsSection: View {
    @State private var ratingsSectionExpanded: Bool = true
    
    var product: Product
    var averageRating: Double
    var productRatingsCount: Int
    
    init(product: Product, averageRating: Double, productRatingsCount: Int) {
        self.product = product
        self.averageRating = averageRating
        self.productRatingsCount = productRatingsCount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            VStack(alignment: .leading) {
                Text("Product Rating")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                
                HStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("\(averageRating, specifier: "%.2f")")
                            .font(.system(size: 26, weight: .bold))
                        HStack {
                            ForEach(1...Int(round(averageRating)), id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.accentColor)
                            }
                            
                            ForEach(Int(round(averageRating))..<5, id: \.self) { _ in
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
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
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
                                    Rectangle()
                                        .foregroundColor(.gray)
                                        .frame(width: 130, height: 7)
                                    Rectangle()
                                        .foregroundColor(.accentColor)
                                        .frame(width: (130 / CGFloat(productRatingsCount)),
                                               height: 7)
                                }
                            }
                        }

                        VStack(spacing: 5) {
                            ForEach(Array(1...5).reversed(), id: \.self) { number in
                                Text("\(product.ratings[number]!.count)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Comments")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.leading)
                    
                    Button(action: {
                        ratingsSectionExpanded.toggle()
                    }, label: {
                        Image(systemName: ratingsSectionExpanded ? "chevron.up" : "chevron.down")
                    })
                }
                
                if ratingsSectionExpanded {
                    ForEach(Array(product.reviews.keys), id: \.self) { reviewAuthor in
                        HStack {
                            HStack(spacing: 0) {
                                Image("blank_profile_image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .frame(width: 100, height: 100)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(reviewAuthor)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    HStack {
                                        HStack(spacing: 5) {
                                            ForEach(1...Int(round(averageRating)), id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.accentColor)
                                            }
                                            
                                            ForEach(Int(round(averageRating))..<5, id: \.self) { _ in
                                                Image(systemName: "star")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.accentColor)
                                            }
                                        }
                                        
                                        Text("•")
                                            .padding(.horizontal, 5)
                                        
                                        Text(Date().dateString())
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                    .padding(.bottom, 10)
                                    
                                    Text(product.reviews[reviewAuthor]!)
                                        .font(.system(size: 16, weight: .regular, design: .rounded))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                                .offset(x: -10)
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
                                             averageRating: 3.55,
                                             productRatingsCount: 10)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
