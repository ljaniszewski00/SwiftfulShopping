//
//  ReturnCreationView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ReturnCreationView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var returnCreationViewModel: ReturnCreationViewModel = ReturnCreationViewModel()
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var order: Order
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                StepsView(stepsNumber: 4, activeStep: 1)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(TexterifyManager.localisedString(key: .returnCreationView(.orderID)))
                        .font(.ssTitle2)
                    Text(returnCreationViewModel.orderForReturn?.id ?? "")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(TexterifyManager.localisedString(key: .returnCreationView(.chooseProducts)))
                        .font(.ssTitle2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    ForEach(returnCreationViewModel.productsFromOrder, id: \.self) { product in
                        Button {
                            withAnimation {
                                returnCreationViewModel.manageProductToReturn(product: product)
                            }
                        } label: {
                            VStack {
                                HStack(alignment: .top) {
                                    Circle()
                                        .if(!returnCreationViewModel.productsForReturn.contains(product)) {
                                            $0
                                                .stroke(lineWidth: 3)
                                        }
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                    BasicProductTile(product: product)
                                }
                                
                                Divider()
                            }
                        }
                    }
                }
                
                HStack {
                    Text(TexterifyManager.localisedString(key: .returnCreationView(.selectedProducts)))
                        .font(.ssTitle2)
                    Text("\(returnCreationViewModel.productsForReturn.count)")
                        .font(.ssTitle2)
                        .foregroundColor(.accentColor)
                }
                
                Button {
                    withAnimation {
                        returnCreationViewModel.shouldPresentSecondReturnCreationView = true
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .returnCreationView(.continueButton)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .disabled(returnCreationViewModel.productsForReturn.isEmpty)
                .contentShape(Rectangle())
            }
            .padding()
            .padding(.bottom, tabBarStateManager.tabBarSize.height * 0.6)
        }
        .navigationTitle(TexterifyManager.localisedString(key: .returnCreationView(.navigationTitle)))
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
            returnCreationViewModel.orderForReturn = order
            returnCreationViewModel.getProductsForReturn()
        }
        
        NavigationLink(destination: SecondReturnCreationView()
                                        .environmentObject(returnCreationViewModel),
                       isActive: $returnCreationViewModel.shouldPresentSecondReturnCreationView) { EmptyView() }
            .isDetailLink(false)
    }
}

struct ReturnCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnCreationView(order: Order.demoOrders[0])
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
