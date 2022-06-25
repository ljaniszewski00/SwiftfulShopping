//
//  OrdersView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        List {
            ForEach(profileViewModel.datesForOrdersViewListSections, id: \.self) { stringDate in
                Section {
                    ForEach(profileViewModel.getOrdersFor(date: stringDate), id: \.self) { order in
                        NavigationLink(destination: OrderDetailsView(order: order)) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 10) {
                                    Text(order.id)
                                    Spacer()
                                    Text(Date.getDayAndMonthFrom(date: order.orderDate))
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.accentColor)
                                        .padding(.trailing, 20)
                                }
                                
                                Text("\(order.totalCost, specifier: "%.2f")")
                                    .font(.system(size: 20, weight: .medium))
                                
                                HStack {
                                    Text("Total Products:")
                                    Text("\(order.shoppingCart.products.count)")
                                        .foregroundColor(.accentColor)
                                }
                                    
                                HStack {
                                    Text("Order Status:")
                                    Text(order.status.rawValue)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                } header: {
                    Text(stringDate)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.accentColor)
                }
            }
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
        .listStyle(.grouped)
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrdersView()
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
