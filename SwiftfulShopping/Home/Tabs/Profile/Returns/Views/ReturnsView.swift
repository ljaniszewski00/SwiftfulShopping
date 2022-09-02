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
                                        .font(.ssCallout)
                                    Spacer()
                                    Text(Date.getDayAndMonthFrom(date: userReturn.returnDate))
                                        .font(.ssTitle3)
                                        .foregroundColor(.accentColor)
                                }
                                
                                Text("\(userReturn.returnPrice, specifier: "%.2f")")
                                    .font(.ssTitle3)
                                    .foregroundColor(.accentColor)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Products:")
                                            .font(.ssCallout)
                                        Text("\(userReturn.products.count)")
                                            .font(.ssTitle3)
                                            .foregroundColor(.accentColor)
                                    }
                                        
                                    HStack {
                                        Text("Return Status:")
                                            .font(.ssCallout)
                                        Text(userReturn.status.rawValue)
                                            .font(.ssTitle3)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                } header: {
                    Text(stringDate)
                        .font(.ssTitle1)
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
