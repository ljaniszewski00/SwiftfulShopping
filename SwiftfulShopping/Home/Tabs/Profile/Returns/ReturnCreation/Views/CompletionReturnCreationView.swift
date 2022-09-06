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
        VStack(alignment: .center) {
            StepsView(stepsNumber: 4, activeStep: 4)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("You have successfuly created a return!")
                        .font(.ssTitle1)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Text("Please wait patiently for hearing from us soon")
                        .font(.ssCallout)
                        .foregroundColor(.ssDarkGray)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Return number")
                        .font(.ssTitle2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Text(returnCreationViewModel.createdReturn?.id ?? "")
                        .font(.ssTitle3)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Money to be returned:")
                        .font(.ssTitle2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Text("$\(returnCreationViewModel.createdReturn?.returnPrice ?? 0, specifier: "%.2f")")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    profileViewModel.shouldPresentReturnCreationView = false
                }
            } label: {
                Text("Close")
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
        }
        .padding()
        .navigationTitle("Return created")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
