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
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State private var presentOrdersView: Bool = false
    @State private var presentReturnsView: Bool = false
    @State private var presentPersonalDataView: Bool = false
    @State private var presentPaymentDetailsView: Bool = false
    @State private var presentHelpView: Bool = false
    
    var body: some View {
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
                    
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: EmptyView(), isActive: $presentOrdersView) {
                                Button("Orders") {
                                    withAnimation() {
                                        presentOrdersView = true
                                    }
                                }
                                .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, rightChevronNavigationImage: true))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom, 20)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: EmptyView(), isActive: $presentOrdersView) {
                                Button("Returns") {
                                    withAnimation() {
                                        presentOrdersView = true
                                    }
                                }
                                .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, rightChevronNavigationImage: true))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom, 20)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: EmptyView(), isActive: $presentOrdersView) {
                                Button("Personal Info") {
                                    withAnimation() {
                                        presentOrdersView = true
                                    }
                                }
                                .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, rightChevronNavigationImage: true))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom, 20)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: EmptyView(), isActive: $presentOrdersView) {
                                Button("Payment Details") {
                                    withAnimation() {
                                        presentOrdersView = true
                                    }
                                }
                                .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, rightChevronNavigationImage: true))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom, 20)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: EmptyView(), isActive: $presentOrdersView) {
                                Button("Help") {
                                    withAnimation() {
                                        presentOrdersView = true
                                    }
                                }
                                .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, rightChevronNavigationImage: true))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom, 20)
                            }
                            Spacer()
                        }
                    }
                    
                    
                } else {
                    Text("Hello, \(profileViewModel.profile.firstName)")
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
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
                    }
                }
    }
}
