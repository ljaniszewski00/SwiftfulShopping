//
//  ReturnsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct ReturnsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        List {
            ForEach(profileViewModel.datesForReturnsViewListSections, id: \.self) { stringDate in
                Section {
                    ForEach(profileViewModel.getReturnsFor(date: stringDate), id: \.self) { userReturn in
                        NavigationLink(destination: ReturnDetailsView(userReturn: userReturn)) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 10) {
                                    Text(userReturn.id)
                                    Spacer()
                                    Text(Date.getDayAndMonthFrom(date: userReturn.returnDate))
                                        .font(.system(size: 18, weight: .medium, design: .rounded))
                                        .foregroundColor(.accentColor)
                                        .padding(.trailing, 20)
                                }
                                
                                Text("\(userReturn.returnPrice, specifier: "%.2f")")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                
                                HStack {
                                    Text("Total Products:")
                                    Text("\(userReturn.products.count)")
                                        .foregroundColor(.accentColor)
                                }
                                    
                                HStack {
                                    Text("Order Status:")
                                    Text(userReturn.status.rawValue)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                } header: {
                    Text(stringDate)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
            }
            .navigationTitle("Returns")
            .navigationBarTitleDisplayMode(.inline)
        }
        .listStyle(.grouped)
    }
}

struct ReturnsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnsView()
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
