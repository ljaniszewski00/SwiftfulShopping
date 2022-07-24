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
    
    @State private var showProductsList: Bool = true
    
    var userReturn: Return
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Return Date")
                        .font(.system(size: 18, design: .rounded))
                    Text(Date.getDayMonthYearFrom(date: userReturn.returnDate))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status")
                            .font(.system(size: 18, design: .rounded))
                            
                        Text(userReturn.status.rawValue)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        showProductsList.toggle()
                    }, label: {
                        Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                    })
                    .padding(.trailing)
                }
                
                if showProductsList {
                    ForEach(userReturn.products, id: \.self) { product in
                        HStack(alignment: .top) {
                            Image("product_placeholder_image")
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack(alignment: .leading, spacing: 20) {
                                Text(product.id)
                                    .font(.system(size: 16, design: .rounded))
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(product.name)
                                            .font(.system(size: 16, design: .rounded))
                                        Text(product.company)
                                            .font(.system(size: 16, design: .rounded))
                                    }
                                    .font(.system(size: 18))
                                    Spacer()
                                    Text("\(product.price, specifier: "%.2f")")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.accentColor)
                                }
                                
                                
                            }
                        }
                        Divider()
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total price to be returned")
                        .font(.system(size: 18, design: .rounded))
                        
                    Text("\(userReturn.returnPrice, specifier: "%.2f")")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
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
