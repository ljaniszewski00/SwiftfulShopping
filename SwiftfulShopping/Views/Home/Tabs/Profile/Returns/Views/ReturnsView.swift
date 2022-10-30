//
//  ReturnsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct ReturnsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var returnsViewModel: ReturnsViewModel = ReturnsViewModel()
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        List {
            ForEach(returnsViewModel.datesForReturnsViewListSections, id: \.self) { stringDate in
                Section {
                    ForEach(returnsViewModel.getReturnsFor(date: stringDate), id: \.self) { userReturn in
                        NavigationLink(destination: ReturnDetailsView(userReturn: userReturn,
                                                                      returnProductsList:
                                                                        returnsViewModel.getReturnProductsFor(returnObject: userReturn))
                                                                            .environmentObject(returnsViewModel)) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 10) {
                                    Text(userReturn.id)
                                        .font(.ssCallout)
                                    Spacer()
                                    Text(Date.getDayAndMonthFrom(date: userReturn.returnDate))
                                        .font(.ssTitle3)
                                        .foregroundColor(.accentColor)
                                }
                                
                                Text("$\(userReturn.returnPrice, specifier: "%.2f")")
                                    .font(.ssTitle3)
                                    .foregroundColor(.accentColor)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Products:")
                                            .font(.ssCallout)
                                        Text("\(returnsViewModel.getReturnProductsFor(returnObject: userReturn).count)")
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
        }
        .listStyle(.grouped)
        .navigationTitle("Returns")
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
            returnsViewModel.userReturns = profileViewModel.userReturns
        }
        .refreshable {
            profileViewModel.fetchUserReturns {
                returnsViewModel.userReturns = profileViewModel.userReturns
            }
        }
    }
}

struct ReturnsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ReturnsView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
