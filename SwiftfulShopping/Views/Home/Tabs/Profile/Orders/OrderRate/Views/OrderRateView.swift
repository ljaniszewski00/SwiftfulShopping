//
//  OrderRateView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrderRateView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var ratingViewModel: RatingViewModel = RatingViewModel()
    
    var order: Order
    @State var orderProductsList: [Product] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(orderProductsList), id: \.self) { product in
                    BasicProductTile(product: product,
                                     includeRateButton: true)
                        .environmentObject(ratingViewModel)
                }
            }
            
            NavigationLink(destination: SingleProductRatingView()
                                            .environmentObject(ratingViewModel),
                           isActive: $ratingViewModel.shouldPresentSingleProductRatingPage) { EmptyView() }
                .isDetailLink(false)
        }
        .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
        .navigationTitle(TexterifyManager.localisedString(key: .orderRateView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.large)
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
        }
        .onAppear {
            self.orderProductsList = ratingViewModel.getProductsListForOrderRating(order: order)
        }
    }
}

struct OrderRateView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderRateView(order: Order.demoOrders[0])
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
