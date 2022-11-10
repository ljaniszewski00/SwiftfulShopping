//
//  OrdersView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrdersView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var ordersViewModel: OrdersViewModel = OrdersViewModel()
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        List {
            ForEach(ordersViewModel.datesForOrdersViewListSections, id: \.self) { stringDate in
                Section {
                    ForEach(ordersViewModel.getOrdersFor(date: stringDate), id: \.self) { order in
                        NavigationLink(destination: OrderDetailsView(order: order,
                                                                     orderProductsList: ordersViewModel.getOrderProductsFor(order: order))
                                                                                            .environmentObject(ordersViewModel)) {
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
                                        Text(TexterifyManager.localisedString(key: .ordersView(.products)))
                                            .font(.ssCallout)
                                        Text("\(ordersViewModel.getOrderProductsFor(order: order).count)")
                                            .font(.ssTitle3)
                                            .foregroundColor(.accentColor)
                                    }
                                        
                                    HStack {
                                        Text(TexterifyManager.localisedString(key: .ordersView(.orderStatus)))
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
        .refreshable {
            profileViewModel.fetchUserOrders {
                ordersViewModel.userOrders = profileViewModel.userOrders
            }
        }
        .navigationTitle(TexterifyManager.localisedString(key: .ordersView(.navigationTitle)))
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
        .onAppear {
            ordersViewModel.userOrders = profileViewModel.userOrders
        }
        .refreshable {
            profileViewModel.fetchUserOrders {
                ordersViewModel.userOrders = profileViewModel.userOrders
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrdersView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
