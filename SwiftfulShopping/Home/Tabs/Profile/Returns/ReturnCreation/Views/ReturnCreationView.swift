//
//  ReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI

struct ReturnCreationView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var returnCreationViewModel: ReturnCreationViewModel = ReturnCreationViewModel()
    
    var order: Order
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 40) {
                StepsView(stepsNumber: 4, activeStep: 1)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Order ID")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text(returnCreationViewModel.orderForReturn?.id ?? "")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("Choose products you want to return")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    ForEach(Array(returnCreationViewModel.orderForReturn?.shoppingCart.products.keys ?? Cart.demoCart.products.keys), id: \.self) { product in
                        Button {
                            withAnimation {
                                returnCreationViewModel.manageProductToReturn(product: product)
                            }
                        } label: {
                            VStack {
                                HStack(alignment: .top) {
                                    if returnCreationViewModel.productsForReturn.contains(product) {
                                        Circle()
                                            .foregroundColor(.accentColor)
                                            .frame(width: 25)
                                    } else {
                                        Circle()
                                            .stroke(lineWidth: 3)
                                            .foregroundColor(.accentColor)
                                            .frame(width: 25)
                                    }
                                    BasicProductTile(product: product)
                                }
                                
                                Divider()
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Selected Products:")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("\(returnCreationViewModel.productsForReturn.count)")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                Button {
                    withAnimation {
                        returnCreationViewModel.shouldPresentSecondReturnCreationView = true
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .disabled(returnCreationViewModel.productsForReturn.isEmpty)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .contentShape(Rectangle())
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Create Return")
        .onAppear {
            returnCreationViewModel.orderForReturn = order
        }
        
        NavigationLink(destination: SecondReturnCreationView()
                                        .environmentObject(authStateManager)
                                        .environmentObject(tabBarStateManager)
                                        .environmentObject(profileViewModel)
                                        .environmentObject(returnCreationViewModel),
                       isActive: $returnCreationViewModel.shouldPresentSecondReturnCreationView) { EmptyView() }
    }
}

struct ReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnCreationView(order: Order.demoOrders[0])
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
