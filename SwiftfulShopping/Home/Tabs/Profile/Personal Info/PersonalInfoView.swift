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
    
    @StateObject private var personalInfoViewModel: PersonalInfoViewModel = PersonalInfoViewModel()
    
    @State private var isBankAccountTextFieldFocused: Bool = false
    @State private var isBankAccountHolderFirstNameTextFieldFocused: Bool = false
    @State private var isBankAccountHolderAddressTextFieldFocused: Bool = false
    @State private var isBankAccountHolderZipCodeTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCityTextFieldFocused: Bool = false
    @State private var isBankAccountHolderCountryTextFieldFocused: Bool = false
    
    @State private var addressSectionExpanded: Bool = false
    @State private var shouldPresentEditPersonalInfoView: Bool = false
    @State private var shouldPresentAddNewAddressView: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("First Name")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.firstName)
                                        .font(.system(size: 18))
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.accentColor)
                                        .padding()
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                shouldPresentEditPersonalInfoView = true
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Last Name")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.lastName)
                                        .font(.system(size: 18))
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.accentColor)
                                        .padding()
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                shouldPresentEditPersonalInfoView = true
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email Address")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.accentColor)
                                HStack {
                                    Text(profileViewModel.profile.email)
                                        .font(.system(size: 18))
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.accentColor)
                                        .padding()
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                shouldPresentEditPersonalInfoView = true
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Address")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .trailing) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .if(!addressSectionExpanded) {
                                            $0
                                                .stroke(lineWidth: 2)
                                        }
                                        .foregroundColor(.accentColor)
                                    HStack {
                                        Text(profileViewModel.profile.address.description)
                                            .font(.system(size: 18))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding()
                                        Spacer()
                                    }
                                    Image(systemName: addressSectionExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(addressSectionExpanded ? .white : .accentColor)
                                        .frame(width: 50, height: 50)
                                        .padding()
                                        .isHidden(profileViewModel.profile.otherAddresses.isEmpty)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    addressSectionExpanded.toggle()
                                }
                                
                                if addressSectionExpanded {
                                    ForEach(profileViewModel.profile.otherAddresses, id: \.self) { address in
                                        ZStack(alignment: .trailing) {
                                            Button {
                                                profileViewModel.changeDefaultAddress(address: address)
                                                addressSectionExpanded = false
                                            } label: {
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 3)
                                                        .stroke(lineWidth: 2)
                                                        .foregroundColor(.accentColor)
                                                    HStack {
                                                        Text(address.description)
                                                            .font(.system(size: 18))
                                                            .fixedSize(horizontal: false, vertical: true)
                                                            .foregroundColor(colorScheme == .light ? .black : .white)
                                                            .padding()
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            
                                            Button {
                                                profileViewModel.removeAddress(address: address)
                                            } label: {
                                                Image(systemName: "trash")
                                            }
                                            .frame(width: 50, height: 50)
                                            .padding()
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    
                                    Button {
                                        withAnimation {
                                            shouldPresentAddNewAddressView = true
                                        }
                                    } label: {
                                        Text("Add New Address")
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                    }
                                    .contentShape(Rectangle())
                                    .buttonStyle(CustomButton(buttonColor: .accentColor, imageName: "plus.circle"))
                                    .padding(.vertical, 10)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
        .navigationTitle("Personal Information")
        
        NavigationLink(destination: AddNewAddressView()
                                        .environmentObject(authStateManager)
                                        .environmentObject(tabBarStateManager)
                                        .environmentObject(profileViewModel)
                                        .environmentObject(personalInfoViewModel),
                       isActive: $shouldPresentAddNewAddressView) { EmptyView() }
        
        NavigationLink(destination: EditPersonalInfoView()
                                        .environmentObject(authStateManager)
                                        .environmentObject(tabBarStateManager)
                                        .environmentObject(profileViewModel)
                                        .environmentObject(personalInfoViewModel)
                                        .onAppear {
                                            personalInfoViewModel.newFirstName = profileViewModel.profile.firstName
                                            personalInfoViewModel.newLastName = profileViewModel.profile.lastName
                                            personalInfoViewModel.newEmailAddress = profileViewModel.profile.email
                                        },
                       isActive: $shouldPresentEditPersonalInfoView) { EmptyView() }
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
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
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
