//
//  SearchView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .scrollOnOverflow()
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
