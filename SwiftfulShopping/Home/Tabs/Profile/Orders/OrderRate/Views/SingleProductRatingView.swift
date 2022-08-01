//
//  SingleProductRatingView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/08/2022.
//

import SwiftUI

struct SingleProductRatingView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var ratingViewModel: RatingViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    BasicProductTile(product: ratingViewModel.activeProduct ?? Product.demoProducts[0])
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("How do you find the product?")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        HStack {
                            ForEach(1...5, id: \.self) { starNumber in
                                Button {
                                    ratingViewModel.setProductRating(rating: starNumber)
                                } label: {
                                    Image(systemName:
                                            starNumber <= ratingViewModel.productRating ? "star.fill" : "star"
                                    )
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(0.5)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Please, write a few words about it.")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        VStack(alignment: .trailing, spacing: 5) {
                            TextEditor(text: $ratingViewModel.textForRating)
                                .frame(minWidth: 0,
                                       maxWidth:
                                        ScreenBoundsSupplier.shared.getScreenWidth() * 0.9,
                                       minHeight: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2,
                                       maxHeight:
                                        ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                                .border(Color.accentColor)
                            
                            Text("\(ratingViewModel.textForRating.count) / 300")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(ratingViewModel.ratingTextTooLong ? .red : .gray)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            ratingViewModel.applyProductRating()
                            dismiss()
                        }
                    } label: {
                        Text("Add opinion")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton(textColor: .white))
                    .disabled(ratingViewModel.cannotAddOpinion)
                }
                .padding()
            }
        }
        .onDisappear {
            ratingViewModel.clearForNextProduct()
        }
    }
}

struct SingleProductRatingView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let ratingViewModel = RatingViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SingleProductRatingView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(ratingViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        ratingViewModel.activeProduct = Product.demoProducts[0]
                    }
            }
        }
    }
}
