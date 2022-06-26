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
    @State private var shouldPresentReturnCreationView = false
    
    var order: Order
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Order Date")
                        .font(.system(size: 20))
                    Text(Date.getDayMonthYearFrom(date: order.orderDate))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
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
                .padding(.bottom, 20)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status")
                            .font(.system(size: 20))
                            
                        Text("Placed")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        showProductsList.toggle()
                    }, label: {
                        Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                    })
                    .padding(.trailing)
                }
                
                if showProductsList {
                    ForEach(order.shoppingCart.products, id: \.self) { product in
                        HStack(alignment: .top) {
                            Image("product_placeholder_image")
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack(alignment: .leading, spacing: 20) {
                                Text(product.id)
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(product.name)
                                        Text(product.company)
                                    }
                                    .font(.system(size: 20))
                                    Spacer()
                                    Text("\(product.price, specifier: "%.2f")")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.accentColor)
                                }
                                
                                
                            }
                        }
                        Divider()
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Price")
                        .font(.system(size: 20))
                        
                    Text("\(order.totalCost, specifier: "%.2f")")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
                Button("Return") {
                    withAnimation {
                        shouldPresentReturnCreationView = true
                    }
                }
                .buttonStyle(CustomButton())
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .contentShape(Rectangle())
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Order No. \(order.id)")
        .navigationBarTitleDisplayMode(.inline)
        
        NavigationLink(destination: ReturnCreationView(order: order)
                                        .environmentObject(authStateManager)
                                        .environmentObject(tabBarStateManager)
                                        .environmentObject(profileViewModel),
                       isActive: $shouldPresentReturnCreationView) { EmptyView() }
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
