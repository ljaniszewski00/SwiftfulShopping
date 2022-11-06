//
//  ProductDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ProductDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var productDetailsViewModel: ProductDetailsViewModel = ProductDetailsViewModel()
    @StateObject private var networkNanager = NetworkManager.shared
    
    @State private var expandAddToCart: Bool = false
    
    var product: Product
    var productRatings: [ProductRating]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    Group {
                        if productDetailsViewModel.fetchingProductImages {
                            Image(AssetsNames.productPlaceholder)
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
            
            buildAddToCartPane()
                .zIndex(1)
        }
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
    
    @ViewBuilder
    func buildAddToCartPane() -> some View {
        HStack(alignment: .center) {
            if expandAddToCart {
                HStack(spacing: 0) {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        productDetailsViewModel.decreaseProductQuantity()
                    } label: {
                        ZStack {
                            Circle()
                            Image(systemName: "minus")
                                .foregroundColor(.ssWhite)
                        }
                    }
                    
                    Text(String(productDetailsViewModel.productQuantityToBasket))
                        .font(.ssButton)
                        .foregroundColor(.ssWhite)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(width: 60)
                    
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        productDetailsViewModel.increaseProductQuantity()
                    } label: {
                        ZStack {
                            Circle()
                            Image(systemName: "plus")
                                .foregroundColor(.ssWhite)
                        }
                    }
                }
                .background {
                    Capsule()
                        .foregroundColor(.accentColor)
                        .shadow(color: .black, radius: 5, x: 3, y: 3)
                }
                .animation(.default)
                .transition(.move(edge: .trailing))
                .onSwiped(.right) {
                    withAnimation {
                        expandAddToCart = false
                    }
                }
                .frame(height: 50)
            }
            
            Button {
                withAnimation {
                    expandAddToCart = true
                    if expandAddToCart {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        cartViewModel.addProductToCart(product: product, quantity: productDetailsViewModel.productQuantityToBasket)
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.accentColor)
                        .shadow(color: .black, radius: 5, x: 3, y: 3)
                    
                    Image(systemName: "cart")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.ssWhite)
                        .padding()
                }
            }
            .frame(height: 50)
        }
        .padding(.trailing)
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
