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
    
    @State private var showProductsList: Bool = true
    
    var order: Order
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Order Date")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text(Date.getDayMonthYearFrom(date: order.orderDate))
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Customer Info")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                            Text(order.client.description)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.accentColor)
                                
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Address Info")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                            Text(order.shippingAddress.description)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.accentColor)
                                
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            
                        Text(order.status.rawValue)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        Text("Products")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Button(action: {
                            showProductsList.toggle()
                        }, label: {
                            Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                        })
                        .padding(.trailing)
                    }
                    
                    if showProductsList {
                        ForEach(Array(order.shoppingCart.products.keys), id: \.self) { product in
                            BasicProductTile(product: product)
                            Divider()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Price")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            
                        Text("\(order.totalCost, specifier: "%.2f")")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button {
                    withAnimation {
                        profileViewModel.shouldPresentReturnCreationView = true
                    }
                } label: {
                    Text("Return product")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .contentShape(Rectangle())
                
                Button {
                    withAnimation {
                        profileViewModel.shouldPresentOrderRateView = true
                    }
                } label: {
                    Text("Rate the order")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .contentShape(Rectangle())
            }
            .padding(.bottom, 20)
            
            NavigationLink(destination: OrderRateView(order: order)
                                            .environmentObject(authStateManager)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel),
                           isActive: $profileViewModel.shouldPresentOrderRateView) { EmptyView() }
            
            NavigationLink(destination: ReturnCreationView(order: order)
                                            .environmentObject(authStateManager)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel),
                           isActive: $profileViewModel.shouldPresentReturnCreationView) { EmptyView() }
            
        }
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
