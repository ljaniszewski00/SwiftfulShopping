//
//  ProductTileForRateView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/08/2022.
//

import SwiftUI

struct ProductTileForRateView: View {
    @EnvironmentObject private var ratingViewModel: RatingViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BasicProductTile(product: product)
                .padding(.bottom, 10)
            
            Button {
                withAnimation {
                    ratingViewModel.activeProduct = product
                    ratingViewModel.shouldPresentSingleProductRatingPage = true
                }
            } label: {
                Text("Rate product")
                    .fontWeight(.bold)
                    .foregroundColor(.ssWhite)
                    .padding(.all, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                    }
            }
        }
    }
}

struct ProductTileForRateView_Previews: PreviewProvider {
    static var previews: some View {
        let ratingViewModel = RatingViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductTileForRateView(product: Product.demoProducts[0])
                    .environmentObject(ratingViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
