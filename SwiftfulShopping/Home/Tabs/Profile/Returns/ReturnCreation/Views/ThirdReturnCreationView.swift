//
//  ThirdReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI

struct ThirdReturnCreationView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var returnCreationViewModel: ReturnCreationViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            StepsView(stepsNumber: 4, activeStep: 3)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("How do you want to return the product?")
                    .font(.ssTitle2)
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(ShippingMethod.allCases, id: \.self) { shippingMethod in
                        Button(action: {
                            withAnimation {
                                returnCreationViewModel.shippingMethod = shippingMethod
                            }
                        }, label: {
                            HStack(spacing: 15) {
                                if returnCreationViewModel.shippingMethod == shippingMethod {
                                    Circle()
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                } else {
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                }
                                
                                Text(shippingMethod.rawValue)
                                    .font(.ssTitle3)
                                    .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                            }
                        })
                        .frame(height: 30)
                    }
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    returnCreationViewModel.createReturn(clientID: profileViewModel.profile.id, orderID: returnCreationViewModel.orderForReturn!.id)
                    profileViewModel.returns.append(returnCreationViewModel.createdReturn!)
                    
                    returnCreationViewModel.shouldPresentCompletionReturnCreationView = true
                }
            } label: {
                Text("Create Return")
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
            .contentShape(Rectangle())
            
            NavigationLink(destination: CompletionReturnCreationView()
                                            .environmentObject(authStateManager)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel)
                                            .environmentObject(returnCreationViewModel),
                           isActive: $returnCreationViewModel.shouldPresentCompletionReturnCreationView) { EmptyView() }
        }
        .padding()
        .navigationTitle("Create Return")
    }
}

struct ThirdReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let returnCreationViewModel = ReturnCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ThirdReturnCreationView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(returnCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                        returnCreationViewModel.orderForReturn = Order.demoOrders[0]
                    }
            }
        }
    }
}
