//
//  CompletionReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import SwiftUI

struct CompletionReturnCreationView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var returnCreationViewModel: ReturnCreationViewModel
    
    var body: some View {
        if returnCreationViewModel.shouldPresentProfileView {
            withAnimation {
                ProfileView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .navigationBarHidden(true)
            }
        } else {
            VStack(alignment: .center) {
                StepsView(stepsNumber: 4, activeStep: 4)
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("You have successfuly created a return!")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        Text("Please wait patiently for hearing from us soon")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.ssGray)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Return number")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text(returnCreationViewModel.createdReturn?.id ?? "")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Money to be returned:")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text("\(returnCreationViewModel.createdReturn?.returnPrice ?? 0, specifier: "%.2f")")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
                
                Spacer()
                
                Button {
                    withAnimation {
                        returnCreationViewModel.shouldPresentProfileView = true
                    }
                } label: {
                    Text("Close")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                .padding(.bottom, 15)
            }
            .navigationTitle("Return created")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CompletionReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let returnCreationViewModel = ReturnCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CompletionReturnCreationView()
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
                        returnCreationViewModel.createdReturn = Return.demoReturns[0]
                    }
            }
        }
    }
}
