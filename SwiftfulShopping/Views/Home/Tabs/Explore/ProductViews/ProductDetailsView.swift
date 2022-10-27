//
//  ProductDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI

struct ProductDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    @StateObject private var productDetailsViewModel: ProductDetailsViewModel = ProductDetailsViewModel()
    @StateObject private var networkNanager = NetworkManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showAllDescription: Bool = false
    
    var product: Product
    var productRatings: [ProductRating]
    
    var productDescription: String {
        showAllDescription ? product.productDescription : String(self.product.productDescription.prefix(80) + "...")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    Group {
                        if productDetailsViewModel.fetchingProductImages {
                            Image("product_placeholder_image")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400, alignment: .center)
                                .clipped()
                        } else {
                            GeometryReader { geometry in
                                ImagesCarouselView(numberOfImages: productDetailsViewModel.productImages.count) {
                                    ForEach(productDetailsViewModel.productImages, id: \.self) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width,
                                                   height: geometry.size.height)
                                            .clipped()
                                    }
                                }
                            }
                            .frame(height: 400, alignment: .center)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .center, spacing: 15) {
                        Text(product.company)
                            .font(.ssTitle3)
                            .foregroundColor(.ssDarkGray)
                        Text(product.name)
                            .font(.ssTitle1)
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.ssTitle2)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                ExpandableText(product.productDescription, lineLimit: 3)
            
                                Spacer()
                            }
                        }
                        
                        ProductDetailsRatingsSection(product: product,
                                                     productRatings: productRatings)
                    }
                    .padding()
                }
            }
            
            HStack {
                QuantityInput(quantity: productDetailsViewModel.productQuantityToBasket,
                              minusAction: {
                    productDetailsViewModel.decreaseProductQuantity()
                },
                              plusAction: {
                    productDetailsViewModel.increaseProductQuantity()
                })
                
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    cartViewModel.addProductToCart(product: product, quantity: productDetailsViewModel.productQuantityToBasket)
                } label: {
                    Text("Add to basket")
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .padding(.leading)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground)
                        )
                    .ignoresSafeArea()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if favoritesViewModel.favoriteProducts.contains(product) {
                    Button {
                        favoritesViewModel.removeFromFavorites(product: product)
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 28, height: 25)
                    }
                } else {
                    Button {
                        favoritesViewModel.addToFavorites(product: product)
                    } label: {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 28, height: 25)
                    }
                }
            }
        }
        .onAppear {
            productDetailsViewModel.fetchProductImages(productImagesURLs: product.imagesURLs)
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let searchViewModel = SearchViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductDetailsView(product: Product.demoProducts[1],
                                   productRatings: ProductRating.demoProductsRatings)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(searchViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
