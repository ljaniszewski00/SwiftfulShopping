//
//  ExploreView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    
    var body: some View {
        NavigationView {
            Text("")
                .navigationTitle("Explore")
        }
        
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
