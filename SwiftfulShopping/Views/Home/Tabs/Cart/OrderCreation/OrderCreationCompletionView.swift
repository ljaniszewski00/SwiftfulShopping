//
//  OrderCreationCompletionView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrderCreationCompletionView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    StepsView(stepsNumber: 4, activeStep: 4)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.youHaveSuccessfullyPlacedYourOrder)))
                                .font(.ssTitle2)
                            
                            Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.pleaseWaitPatiently)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                        }
                        
                        HStack {
                            Spacer()
                            LottieView(name: LottieAssetsNames.successfulOrderCreation, loopMode: .playOnce, contentMode: .scaleAspectFill)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5,
                                       height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.25)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 30) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.orderNumber)))
                                    .font(.ssTitle3)
                                Text(orderCreationViewModel.createdOrder?.id ?? "")
                                    .font(.ssCallout)
                                    .foregroundColor(.accentColor)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.expectedDeliveryDate)))
                                    .font(.ssTitle3)
                                Text(orderCreationViewModel.createdOrder?.estimatedDeliveryDate.dateString() ?? "")
                                    .font(.ssCallout)
                                    .foregroundColor(.accentColor)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            cartViewModel.removeAllProductsFromCart()
                            cartViewModel.shouldPresentCheckoutFirstView = false
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .orderCreationCompletionView(.goBackToCart)))
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton())
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .navigationTitle(TexterifyManager.localisedString(key: .orderCreationCompletionView(.navigationTitle)))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct OrderCreationCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let orderCreationViewModel = OrderCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationCompletionView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(orderCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        orderCreationViewModel.createdOrder = Order.demoOrders[0]
                    }
            }
        }
    }
}
