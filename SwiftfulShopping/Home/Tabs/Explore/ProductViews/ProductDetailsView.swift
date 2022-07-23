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
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 30) {
                    if let product = exploreViewModel.currentProduct {
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
                        .ignoresSafeArea()

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
                    } else {
                        EmptyView()
                    }
                }
            }
            
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
                            Image(systemName: "minus.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Text("\(exploreViewModel.productQuantityToBasket)")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        
                        Button {
                            withAnimation {
                                exploreViewModel.addOneProduct()
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
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    cartViewModel.addProductToCart(product: exploreViewModel.currentProduct!, quantity: exploreViewModel.productQuantityToBasket)
                } label: {
                    Text("ADD TO BASKET")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("\(exploreViewModel.currentProduct!.name)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductDetailsView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
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
