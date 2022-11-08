//
//  ProductsSpecificationsComparisonView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/11/2022.
//

import SwiftUI

struct ProductsSpecificationsComparisonView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    
    var body: some View {
        VStack {
            if exploreViewModel.productsToBeCompared.isEmpty {
                VStack(spacing: 20) {
                    LottieView(name: LottieAssetsNames.scale,
                               loopMode: .loop,
                               contentMode: .scaleAspectFill)
                        .frame(width: 200, height: 200)
                    Text("Add products to comparison to see their spefications compared here")
                        .font(.ssTitle2)
                        .padding(.horizontal)
                    Spacer()
                }
                .padding(.top, 100)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    
                }
            }
        }
        .padding()
        .navigationTitle("Compare")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProductsSpecificationsComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        let exploreViewModel = ExploreViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductsSpecificationsComparisonView()
                    .environmentObject(exploreViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
