//
//  ProductDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 21/07/2022.
//

import SwiftUI

struct ProductDetailsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    if let product = exploreViewModel.currentProduct {
                        AsyncImage(url: URL(string: product.imageURL)!) { loadedImage in
                            loadedImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image("product_placeholder_image")
                                .resizable()
                                .scaledToFill()
                        }

                        VStack(alignment: .center, spacing: 15) {
                            Text(product.company)
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.gray)
                            Text(product.name)
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                            Text("\(product.price, specifier: "%.2f")")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack {
                            Text(product.productDescription)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                            Spacer()
                        }
                        .padding()
                    } else {
                        EmptyView()
                    }
                }
            }
            .ignoresSafeArea(.container, edges: [.top])
            
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
                            if exploreViewModel.productQuantityToBasket > 1 {
                                withAnimation {
                                    exploreViewModel.removeOneProduct()
                                }
                            }
                        } label: {
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Text("\(exploreViewModel.productQuantityToBasket)")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Button {
                            withAnimation {
                                exploreViewModel.addOneProduct()
                            }
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    cartViewModel.addProductToCart(product: exploreViewModel.currentProduct!, quantity: exploreViewModel.productQuantityToBasket)
                } label: {
                    Text("ADD TO BASKET")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
            }
            .padding(.bottom, 20)
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
                if favoritesViewModel.favoriteProducts.contains(exploreViewModel.currentProduct!) {
                    Button {
                        favoritesViewModel.removeFromFavorites(product: exploreViewModel.currentProduct!)
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 28, height: 25)
                    }
                } else {
                    Button {
                        favoritesViewModel.addToFavorites(product: exploreViewModel.currentProduct!)
                    } label: {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 28, height: 25)
                    }
                }
            }
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductDetailsView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        exploreViewModel.currentProduct = Product.demoProducts[0]
                    }
            }
        }
    }
}
