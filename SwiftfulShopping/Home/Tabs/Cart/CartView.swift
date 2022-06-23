//
//  CartView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
            }
            .navigationTitle("Cart")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
