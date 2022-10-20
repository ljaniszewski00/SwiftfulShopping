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
    
    @StateObject var errorManager = ErrorManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    BasicProductTile(product: ratingViewModel.activeProduct ?? Product.demoProducts[0])
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("How do you find the product?")
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
                        Text("Please, write a few words about it.")
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
                            ratingViewModel.applyProductRating(authorID: profileViewModel.profile.id,
                                                               authorFirstName: profileViewModel.profile.fullName.components(separatedBy: " ").first!) { result in
                                switch result {
                                case .success:
                                    profileViewModel.addUserRating(productID: ratingViewModel.activeProduct!.id, rating: ratingViewModel.productRating, review: ratingViewModel.textForRating)
                                    dismiss()
                                case .failure(let error):
                                    ErrorManager.shared.generateCustomError(errorType: .applyProductRatingError,
                                                                            additionalErrorDescription: error.localizedDescription)
                                }
                            }
                        }
                    } label: {
                        Text("Add opinion")
                            .font(.ssButton)
                    }
                    .buttonStyle(CustomButton(textColor: .ssWhite))
                    .disabled(ratingViewModel.cannotAddOpinion)
                }
                .padding()
            }
            .modifier(LoadingIndicatorModal(isPresented:
                                                $ratingViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
        }
        .navigationTitle("Rate the product")
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
        let authStateManager = AuthStateManager()
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
                        authStateManager.didLogged(with: .emailPassword)
                        ratingViewModel.activeProduct = Product.demoProducts[0]
                    }
            }
        }
    }
}
