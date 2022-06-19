//
//  ProfileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @State private var selection: String? = nil
    
    enum NavigationViewsNames: String, CaseIterable {
        case orders = "Orders"
        case returns = "Returns"
        case personalInfo = "Personal Info"
        case paymentDetails = "Payment Details"
        case help = "Help"
        
        static var allCases: [NavigationViewsNames] {
            return [
                .orders,
                .returns,
                .personalInfo,
                .paymentDetails,
                .help
            ]
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    if authStateManager.isGuest {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Hello, customer!")
                                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                                Text("We are happy to see you again.")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(Color(uiColor: .darkGray))
                                Spacer()
                            }
                            Spacer()
                            VStack(spacing: 20) {
                                Image("blank_profile_image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.2)
                            }
                            .padding(.trailing, 20)
                        }
                        .padding()
                    } else {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Hello, \(profileViewModel.profile.firstName)!")
                                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                                Text("We are happy to see you again.")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(Color(uiColor: .darkGray))
                                Spacer()
                            }
                            Spacer()
                            VStack(spacing: 20) {
                                Image("blank_profile_image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.2)
                                
                                // TODO: Add NavigationLink
                                Button {
                                    
                                } label: {
                                    Text("Edit")
                                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                                }
                            }
                            .padding(.trailing, 20)
                        }
                        .padding()
                        
                        Spacer(minLength: 200)
                        
                        VStack(alignment: .center) {
                            ForEach(NavigationViewsNames.allCases, id: \.self) { navigationViewName in
                                HStack {
                                    Spacer()
                                    Button(navigationViewName.rawValue) {
                                        selection = navigationViewName.rawValue
                                    }
                                    .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, rightChevronNavigationImage: true))
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .contentShape(Rectangle())
                                    .padding(.bottom, 20)
                                    Spacer()
                                }
                            }
                        }
                        
                        NavigationLink(destination: OrdersView(), tag: "Orders", selection: $selection) { EmptyView() }
                        NavigationLink(destination: ReturnsView(), tag: "Returns", selection: $selection) { EmptyView() }
                        NavigationLink(destination: PersonalInfoView(), tag: "Personal Info", selection: $selection) { EmptyView() }
                        NavigationLink(destination: PaymentDetailsView(), tag: "Payment Details", selection: $selection) { EmptyView() }
                        NavigationLink(destination: HelpView(), tag: "Help", selection: $selection) { EmptyView() }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
                    ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                        ProfileView()
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
