//
//  ProductDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI

struct ProductDetailsView: View {
    @State private var productQuantityToBasket: Int = 1
    
    var product: Product
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    AsyncImage(url: URL(string: product.imageURL)!) { loadedImage in
                        loadedImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.22)
                    } placeholder: {
                        Image("product_placeholder_image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.22)
                    }

                    VStack(alignment: .center, spacing: 15) {
                        Text(product.company)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                        Text(product.name)
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                        Text("\(product.price, specifier: "%.2f")")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    
                    HStack {
                        Text(product.productDescription)
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Spacer()
                    }
                    .padding()
                    
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HStack {
                    HStack(spacing: 10) {
                        ForEach(ProductColor.allCases, id: \.self) { color in
                            Button {
                                
                            } label: {
                                Circle()
                                    .foregroundColor(Color(uiColor: color.rawValue))
                                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.08, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.035)
                                    .opacity(0.9)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button {
                            if productQuantityToBasket > 1 {
                                withAnimation {
                                    productQuantityToBasket -= 1
                                }
                            }
                        } label: {
                            Image(systemName: "minus.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Text("\(productQuantityToBasket)")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        
                        Button {
                            withAnimation {
                                productQuantityToBasket += 1
                            }
                        } label: {
                            Image(systemName: "plus.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                
                Button {
                    
                } label: {
                    Text("ADD TO BASKET")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
            }
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductDetailsView(product: Product.demoProducts[0])
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
