//
//  ReturnDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/07/2022.
//

import SwiftUI

struct ReturnDetailsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var showProductsList: Bool = true
    
    var userReturn: Return
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Return Date")
                        .font(.ssTitle2)
                        .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                    
                    Text(Date.getDayMonthYearFrom(date: userReturn.returnDate))
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Status")
                        .font(.ssTitle2)
                        .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                        
                    Text(userReturn.status.rawValue)
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        showProductsList.toggle()
                    }, label: {
                        HStack(spacing: 20) {
                            Text("Products (\(userReturn.products.count))")
                                .font(.ssTitle2)
                                .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                            
                            Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                        }
                    })
                    
                    if showProductsList {
                        VStack(alignment: .center, spacing: 20) {
                            ForEach(userReturn.products, id: \.self) { product in
                                BasicProductTile(product: product)
                                Divider()
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total price to be returned")
                        .font(.ssTitle2)
                        .foregroundColor(colorScheme == .light ? .ssBlack : .ssWhite)
                        
                    Text("$\(userReturn.returnPrice, specifier: "%.2f")")
                        .font(.ssTitle3)
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
        }
        .navigationTitle("Return No. \(userReturn.id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReturnDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnDetailsView(userReturn: profileViewModel.returns[0])
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
