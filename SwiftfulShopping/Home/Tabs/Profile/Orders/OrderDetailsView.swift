//
//  OrderDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/06/2022.
//

import SwiftUI

struct OrderDetailsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(Date.getDayMonthYearFrom(date: order.orderDate))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.accentColor)
            
            Text(order.status.rawValue)
                .font(.system(size: 22, weight: .bold))
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Customer Info")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.accentColor)
                    Text(order.clientInfo)
                        
                }
                Spacer()
                VStack(alignment: .leading, spacing: 15) {
                    Text("Shipping Info")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.accentColor)
                    Text(order.shippingAddress)
                        
                }
            }
        }
        .padding()
        .scrollOnOverflow()
        .navigationTitle("Order No. \(order.id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderDetailsView(order: profileViewModel.orders[0])
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
