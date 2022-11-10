//
//  SingleProductRatingView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct SingleProductRatingView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var ratingViewModel: RatingViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var errorManager = ErrorManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    if let activeProduct = ratingViewModel.activeProduct {
                        BasicProductTile(product: activeProduct)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(TexterifyManager.localisedString(key: .singleProductRatingView(.howDoYouFindProduct)))
                            .font(.ssTitle2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        
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
                        Text(TexterifyManager.localisedString(key: .singleProductRatingView(.pleaseWriteFewWords)))
                            .font(.ssTitle2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        
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
                                .font(.ssCallout)
                                .foregroundColor(ratingViewModel.ratingTextTooLong ? .red : .ssDarkGray)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            if let profile = profileViewModel.profile {
                                ratingViewModel.applyProductRating(authorID: profile.id,
                                                                   authorFirstName: profile.fullName.components(separatedBy: " ").first!) { result in
                                    switch result {
                                    case .success:
                                        profileViewModel.addUserRating(productID: ratingViewModel.activeProduct!.id,
                                                                       rating: ratingViewModel.productRating,
                                                                       review: ratingViewModel.textForRating) { result in
                                            switch result {
                                            case .success:
                                                dismiss()
                                            case .failure(let error):
                                                ErrorManager.shared.generateCustomError(errorType: .applyProductRatingError,
                                                                                        additionalErrorDescription: error.localizedDescription)
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        ErrorManager.shared.generateCustomError(errorType: .applyProductRatingError,
                                                                                additionalErrorDescription: error.localizedDescription)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(TexterifyManager.localisedString(key: .singleProductRatingView(.addRateButton)))
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton(textColor: .ssWhite))
                    .disabled(ratingViewModel.cannotAddOpinion)
                }
                .padding()
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                $ratingViewModel.showLoadingModal))
        }
        .navigationTitle(TexterifyManager.localisedString(key: .singleProductRatingView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
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
        .onDisappear {
            ratingViewModel.clearForNextProduct()
        }
    }
}

struct SingleProductRatingView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let ratingViewModel = RatingViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SingleProductRatingView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(ratingViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        ratingViewModel.activeProduct = Product.demoProducts[0]
                    }
            }
        }
    }
}
