//
//  HomeViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var errorManager = ErrorManager.shared
    
    @Published var showLoadingModal: Bool = false
    
    func generateNetworkError() {
        errorManager.generateCustomError(errorType: .networkError)
    }
}
