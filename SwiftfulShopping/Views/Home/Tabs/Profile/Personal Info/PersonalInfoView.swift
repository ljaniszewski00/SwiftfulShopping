//
//  PersonalInfoView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct PersonalInfoView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var personalInfoViewModel: PersonalInfoViewModel = PersonalInfoViewModel()
    
    @State private var isBankAccountTextFieldFocused: Bool = false
    @State private var isBankAccountHolderFirstNameTextFieldFocused: Bool = false
    @State private var isBankAccountHolderAddressTextFieldFocused: Bool = false
    @State private var isBankAccountHolderZipCodeTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCityTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCountryTextFieldFocused: Bool = false
    
    @State private var shouldPresentEditPersonalInfoView: Bool = false
    @State private var shouldPresentAddNewAddressView: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("First Name")
                                .font(.ssTitle2)
                            
                            Button {
                                shouldPresentEditPersonalInfoView = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.accentColor)
                                    HStack {
                                        Text(profileViewModel.profile.fullName)
                                            .font(.ssTitle3)
                                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                            .padding()
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.accentColor)
                                            .padding()
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email Address")
                                .font(.ssTitle2)
                            
                            Button {
                                shouldPresentEditPersonalInfoView = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.accentColor)
                                    HStack {
                                        Text(profileViewModel.profile.email)
                                            .font(.ssTitle3)
                                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                            .padding()
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.accentColor)
                                            .padding()
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Address")
                                .font(.ssTitle2)
                            
                            SelectionDropdownMenu(selection: $personalInfoViewModel.defaultAddress,
                                                  dataWithImagesToChoose: personalInfoViewModel.addresses,
                                                  includeSearchField: false)
                            .onChange(of: personalInfoViewModel.defaultAddress) { newDefaultAddress in
                                profileViewModel.changeDefaultAddress(addressDescription: newDefaultAddress)
                            }
                            .padding(.bottom)
                            
                            Button {
                                withAnimation {
                                    shouldPresentAddNewAddressView = true
                                }
                            } label: {
                                Text("Add New Address")
                                    .font(.ssButton)
                            }
                            .contentShape(Rectangle())
                            .buttonStyle(CustomButton())
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Personal Information")
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
            personalInfoViewModel.setupAddresses(defaultProfileAddress:
                                                    profileViewModel.profile.defaultShipmentAddress,
                                                 profileAddresses:
                                                    profileViewModel.profile.shipmentAddresses)
        }
        
        NavigationLink(destination: AddNewAddressView()
                                        .environmentObject(personalInfoViewModel),
                       isActive: $shouldPresentAddNewAddressView) { EmptyView() }
        
        NavigationLink(destination: EditPersonalInfoView()
                                        .environmentObject(personalInfoViewModel)
                                        .onAppear {
                                            personalInfoViewModel.newFullName = profileViewModel.profile.fullName
                                            personalInfoViewModel.newEmailAddress = profileViewModel.profile.email
                                        },
                       isActive: $shouldPresentEditPersonalInfoView) { EmptyView() }
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager()
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                PersonalInfoView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.didLogged(with: .emailPassword)
                    }
            }
        }
    }
}
