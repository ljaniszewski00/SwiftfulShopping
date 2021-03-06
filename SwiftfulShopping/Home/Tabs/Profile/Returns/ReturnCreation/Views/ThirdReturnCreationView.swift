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
    
    @State private var shouldProceedReturnCreationView = false
    
    var order: Order
    
    var body: some View {
        if shouldProceedReturnCreationView {
            withAnimation {
                ProfileView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .navigationBarHidden(true)
            }
        } else {
            VStack(alignment: .leading, spacing: 40) {
                StepsView(stepsNumber: 3, activeStep: 3)
                
                Text("Choose products delivery method")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                
                VStack(alignment: .leading) {
                    ForEach(ShippingMethod.allCases, id: \.self) { shippingMethod in
                        HStack {
                            Button(action: {
                                returnCreationViewModel.shippingMethod = shippingMethod
                            }, label: {
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
                            })
                            
                            Text(shippingMethod.rawValue)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .frame(height: 50)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        profileViewModel.returns.append(returnCreationViewModel.createReturn(clientID: profileViewModel.profile.id, orderID: order.id))
                        
                        shouldProceedReturnCreationView = true
                    }
                } label: {
                    Text("Create Return")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .contentShape(Rectangle())
                .padding(.bottom, 20)
            }
            .padding()
            .scrollOnOverflow()
            .navigationTitle("Create Return")
        }
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
                ThirdReturnCreationView(order: profileViewModel.orders[0])
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
                    }
            }
        }
    }
}
