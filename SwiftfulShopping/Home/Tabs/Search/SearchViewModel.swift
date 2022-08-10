//
//  SearchViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 10/08/2022.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var choosenProduct: Product?
    @Published var shouldPresentProductDetailsView: Bool = false
    
    func changeFocusedProductFor(product: Product) {
        choosenProduct = product
        shouldPresentProductDetailsView = true
    }
}
