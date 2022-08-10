//
//  SortingAndFilteringSheetView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import SwiftUI

struct SortingAndFilteringSheetView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SortingAndFilteringSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let exploreViewModel = ExploreViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SortingAndFilteringSheetView()
                    .environmentObject(exploreViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
