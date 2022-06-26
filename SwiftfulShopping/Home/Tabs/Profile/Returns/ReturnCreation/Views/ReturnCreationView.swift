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
    
    @State private var shouldProceedReturnCreationView = false
    
    var order: Order
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 40) {
                StepsView(stepsNumber: 3, activeStep: 1)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Order ID")
                        .font(.system(size: 20))
                    Text(order.id)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("Choose products you want to return")
                        .font(.system(size: 20))
                    ForEach(order.shoppingCart.products, id: \.self) { product in
                        HStack(alignment: .top) {
                            Button(action: {
                                returnCreationViewModel.manageProductToReturn(product: product)
                            }, label: {
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
                            })
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
                
                HStack {
                    Text("Selected Products:")
                        .font(.system(size: 20))
                    Text("\(returnCreationViewModel.productsForReturn.count)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
                Button("Continue") {
                    withAnimation {
                        shouldProceedReturnCreationView = true
                    }
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
        
        NavigationLink(destination: SecondReturnCreationView(order: order)
                                        .environmentObject(authStateManager)
                                        .environmentObject(tabBarStateManager)
                                        .environmentObject(profileViewModel)
                                        .environmentObject(returnCreationViewModel),
                       isActive: $shouldProceedReturnCreationView) { EmptyView() }
    }
}

struct ReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnCreationView(order: profileViewModel.orders[0])
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
