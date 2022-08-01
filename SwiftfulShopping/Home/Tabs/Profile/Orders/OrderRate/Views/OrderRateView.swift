//
//  OrderRateView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import SwiftUI

struct OrderRateView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var ratingViewModel: RatingViewModel = RatingViewModel()
    
    var order: Order
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(order.shoppingCart.products.keys), id: \.self) { product in
                    ProductTileForRateView(product: product)
                        .environmentObject(ratingViewModel)
                }
            }
            
            NavigationLink(destination: SingleProductRatingView()
                                            .environmentObject(authStateManager)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel)
                                            .environmentObject(ratingViewModel),
                           isActive: $ratingViewModel.shouldPresentSingleProductRatingPage) { EmptyView() }
        }
        .navigationTitle("Rate the order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OrderRateView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderRateView(order: profileViewModel.orders[0])
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
