//
//  ReturnDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/07/2022.
//

import SwiftUI

struct ReturnDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var returnsViewModel: ReturnsViewModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var showProductsList: Bool = true
    
    var userReturn: Return
    @State var returnProductsList: [Product]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Return Date")
                        .font(.ssTitle2)
                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    
                    Text(Date.getDayMonthYearFrom(date: userReturn.returnDate))
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Status")
                        .font(.ssTitle2)
                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                    Text(userReturn.status.rawValue)
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        showProductsList.toggle()
                    }, label: {
                        HStack(spacing: 20) {
                            Text("Products (\(returnProductsList.count))")
                                .font(.ssTitle2)
                                .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                            
                            Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                        }
                    })
                    
                    if showProductsList {
                        VStack(alignment: .center, spacing: 20) {
                            ForEach(returnProductsList, id: \.self) { product in
                                BasicProductTile(product: product)
                                Divider()
                            }
                        }
                    }
                }
                HStack {
                    Text("Total return price")
                        .font(.ssTitle2)
                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    
                    Spacer()
                        
                    Text("$\(userReturn.returnPrice, specifier: "%.2f")")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .padding(.bottom, tabBarStateManager.tabBarSize.height * 0.6)
        }
        .navigationTitle("Return No. \(userReturn.id)")
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
            returnProductsList = returnsViewModel.getReturnProductsFor(returnObject: userReturn)
        }
    }
}

struct ReturnDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnDetailsView(userReturn: Return.demoReturns[0],
                                  returnProductsList: [Product.demoProducts[0],
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
