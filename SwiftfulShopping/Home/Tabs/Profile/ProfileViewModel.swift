//
//  ProfileViewModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile = Profile.demoProfile
    @Published var orders: [Order] = Order.demoOrders
    @Published var returns: [Return] = Return.demoReturns
    
}
