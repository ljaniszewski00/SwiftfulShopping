//
//  CompletionReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 31/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct CompletionReturnCreationView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var returnCreationViewModel: ReturnCreationViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            StepsView(stepsNumber: 4, activeStep: 4)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(TexterifyManager.localisedString(key: .completionReturnCreationView(.youHaveSuccessfullyCreatedReturn)))
                        .font(.ssTitle1)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Text(TexterifyManager.localisedString(key: .completionReturnCreationView(.pleaseWaitPatiently)))
                        .font(.ssCallout)
                        .foregroundColor(.ssDarkGray)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(TexterifyManager.localisedString(key: .completionReturnCreationView(.returnNumber)))
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
                    Text(TexterifyManager.localisedString(key: .completionReturnCreationView(.moneyToBeReturned)))
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
                Text(TexterifyManager.localisedString(key: .completionReturnCreationView(.closeButton)))
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
        }
        .padding([.horizontal, .top])
        .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
        .navigationTitle(TexterifyManager.localisedString(key: .completionReturnCreationView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct CompletionReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let returnCreationViewModel = ReturnCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CompletionReturnCreationView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(returnCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        returnCreationViewModel.orderForReturn = Order.demoOrders[0]
                        returnCreationViewModel.createdReturn = Return.demoReturns[0]
                    }
            }
        }
    }
}
