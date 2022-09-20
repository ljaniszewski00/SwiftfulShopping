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
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        List {
            ForEach(profileViewModel.datesForOrdersViewListSections, id: \.self) { stringDate in
                Section {
                    ForEach(profileViewModel.getOrdersFor(date: stringDate), id: \.self) { order in
                        NavigationLink(destination: OrderDetailsView(order: order)) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 10) {
                                    Text(order.id)
                                        .font(.ssCallout)
                                    Spacer()
                                    Text(Date.getDayAndMonthFrom(date: order.orderDate))
                                        .font(.ssTitle3)
                                        .foregroundColor(.accentColor)
                                }
                                
                                Text("$\(order.totalCost, specifier: "%.2f")")
                                    .font(.ssTitle3)
                                    .foregroundColor(.accentColor)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Products:")
                                            .font(.ssCallout)
                                        Text("\(order.shoppingCart.products.count)")
                                            .font(.ssTitle3)
                                            .foregroundColor(.accentColor)
                                    }
                                        
                                    HStack {
                                        Text("Order Status:")
                                            .font(.ssCallout)
                                        Text(order.status.rawValue)
                                            .font(.ssTitle3)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                } header: {
                    Text(stringDate)
                        .font(.ssTitle1)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager()
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
                        authStateManager.didLogged(with: .emailPassword)
                    }
            }
        }
    }
}
