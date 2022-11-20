//
//  ReturnDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ReturnDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var returnsViewModel: ReturnsViewModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var returnDetailsViewModel: ReturnDetailsViewModel = ReturnDetailsViewModel()
    
    @State private var showProductsList: Bool = true
    
    var userReturn: Return
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .returnDetailsView(.returnDate)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(Date.getDayMonthYearFrom(date: userReturn.returnDate))
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .returnDetailsView(.status)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                            
                        Text(userReturn.status.rawValue)
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Button(action: {
                            showProductsList.toggle()
                        }, label: {
                            HStack(spacing: 20) {
                                if let returnAllProductsQuantity = returnDetailsViewModel.returnAllProductsQuantity {
                                    Text("\(TexterifyManager.localisedString(key: .returnDetailsView(.products))) (\(returnAllProductsQuantity))")
                                        .font(.ssTitle2)
                                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                }
                                
                                Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                            }
                        })
                        
                        if showProductsList {
                            if let returnProductsWithQuantity = returnDetailsViewModel.returnProductsWithQuantity {
                                VStack(alignment: .center, spacing: 20) {
                                    ForEach(Array(returnProductsWithQuantity.keys).sorted { $0.name < $1.name },
                                            id: \.self) { product in
                                        if let productQuantity = userReturn.productsIDsWithQuantity[product.id] {
                                            BasicProductTile(product: product, productQuantity: productQuantity)
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Text(TexterifyManager.localisedString(key: .returnDetailsView(.totalReturnPrice)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Spacer()
                        
                        Text(LocaleManager.client.formatPrice(price: userReturn.returnPrice) ?? "")
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
            }
        }
        .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
        .navigationTitle("\(TexterifyManager.localisedString(key: .returnDetailsView(.navigationTitle))) \(userReturn.id)")
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
            returnDetailsViewModel.userReturn = userReturn
        }
    }
}

struct ReturnDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let returnsViewModel = ReturnsViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnDetailsView(userReturn: Return.demoReturns[0])
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(returnsViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
