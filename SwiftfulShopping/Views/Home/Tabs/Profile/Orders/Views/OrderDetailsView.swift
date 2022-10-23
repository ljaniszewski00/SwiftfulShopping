//
//  OrderDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/06/2022.
//

import SwiftUI

struct OrderDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var ordersViewModel: OrdersViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var showProductsList: Bool = true

    var order: Order
    @State var orderProductsList: [Product]
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Order Date")
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(Date.getDayMonthYearFrom(date: order.orderDate))
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Customer Info")
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(order.clientDescription)
                            .font(.ssCallout)
                            .foregroundColor(.accentColor)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Address Info")
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(order.addressDescription)
                            .font(.ssCallout)
                            .foregroundColor(.accentColor)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status")
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                            
                        Text(order.status.rawValue)
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            showProductsList.toggle()
                        }, label: {
                            HStack(spacing: 20) {
                                Text("Products (\(orderProductsList.count))")
                                    .font(.ssTitle2)
                                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                            }
                        })
                        
                        if showProductsList {
                            VStack(alignment: .center, spacing: 20) {
                                ForEach(orderProductsList, id: \.self) { product in
                                    BasicProductTile(product: product)
                                    Divider()
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Text("Total Price")
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Spacer()
                            
                        Text("$\(order.totalCost, specifier: "%.2f")")
                            .font(.ssTitle3)
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
                    Text("Return products")
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                
                Button {
                    withAnimation {
                        profileViewModel.shouldPresentOrderRateView = true
                    }
                } label: {
                    Text("Rate the order")
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                .contentShape(Rectangle())
            }
            .padding()
            
            NavigationLink(destination: OrderRateView(order: order)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel),
                           isActive: $profileViewModel.shouldPresentOrderRateView) { EmptyView() }
                .isDetailLink(false)
            
            NavigationLink(destination: ReturnCreationView(order: order)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel),
                           isActive: $profileViewModel.shouldPresentReturnCreationView) { EmptyView() }
                .isDetailLink(false)
            
        }
        .padding(.bottom, tabBarStateManager.tabBarSize.height * 0.6)
        .navigationTitle("Order No. \(order.id)")
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
            
        }
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderDetailsView(order: Order.demoOrders[0],
                                 orderProductsList: [Product.demoProducts[0],
                                                     Product.demoProducts[1]])
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
