//
//  SettingsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    @StateObject private var networkNanager = NetworkManager.shared
    
    @State private var selection: String?
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    enum NavigationViewsNames: String, CaseIterable {
        case changeEmail = "Change Email"
        case changePassword = "Change Password"
        case deleteAccount = "Delete Account"
        
        static var allCases: [NavigationViewsNames] {
            return [
                .changeEmail,
                .changePassword,
                .deleteAccount
            ]
        }
    }
    
    private var navigationIconsForNames: [NavigationViewsNames: String] = [.changeEmail: "envelope.fill",
                                                                   .changePassword: "key.fill",
                                                                   .deleteAccount: "person.badge.minus"]
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $settingsViewModel.notifications, label: {
                    HStack(spacing: 20) {
                        Image(systemName: "bell.circle.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Notifications")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                
                Toggle(isOn: $settingsViewModel.biometricLock, label: {
                    HStack(spacing: 20) {
                        Image(systemName: "faceid")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Biometric Lock")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                
                NavigationLink(destination: AccentColorChangeView()
                                                .environmentObject(accentColorManager),
                               isActive: $settingsViewModel.shouldPresentAccentColorChangeView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "circle.hexagonpath.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Change Accent Color")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                
                NavigationLink(destination: ColorSchemeChangeView()
                                                .environmentObject(settingsViewModel),
                               isActive: $settingsViewModel.shouldPresentColorSchemeChangeView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "moon.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Manage Dark Mode")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
            } header: {
                Text("App settings")
            } footer: {
                Text("Make shopping as easy as possible by personalizing the app to the maximum")
            }
            
            Section {
                NavigationLink(destination: ChangeEmailView()
                                                .environmentObject(authStateManager)
                                                .environmentObject(settingsViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $settingsViewModel.shouldPresentChangeEmailView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "envelope.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Change Email")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                .disabled(!networkNanager.isConnected)
                
                NavigationLink(destination: ChangePasswordView()
                                                .environmentObject(authStateManager)
                                                .environmentObject(settingsViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $settingsViewModel.shouldPresentChangePasswordView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "key.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Change Password")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                .disabled(!networkNanager.isConnected)
                
                NavigationLink(destination: DeleteAccountView()
                                                .environmentObject(authStateManager)
                                                .environmentObject(settingsViewModel)
                                                .onAppear {
                                                    withAnimation() {
                                                        tabBarStateManager.hideTabBar()
                                                    }
                                                    
                                                },
                               isActive: $settingsViewModel.shouldPresentDeleteAccountView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "person.fill.badge.minus")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Delete Account")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                .disabled(!networkNanager.isConnected)
            } header: {
                Text("Account actions")
            } footer: {
                Text("Here you can manage your account")
            }
            
            Section {
                NavigationLink(destination: EmptyView(),
                               isActive: $settingsViewModel.shouldShowOnboarding,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "questionmark.square.dashed")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Show Onboarding")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                    }
                })
                
                Button(action: {
                    settingsViewModel.openAuthorGitHubPrivacyPolicyURL()
                }, label: {
                    HStack(spacing: 20) {
                        Image(systemName: "newspaper.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Terms and Conditions")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                })
                
                HStack(spacing: 20) {
                    Image(systemName: "link.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .frame(width: 30)
                    Text("Follow me on GitHub:")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .fixedSize(horizontal: true, vertical: false)
                    Link("ljaniszewski00", destination: settingsViewModel.authorGitHubURL)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            } header: {
                Text("Additional")
            } footer: {
                Text("")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tabBarStateManager.showTabBar()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let accentColorManager = AccentColorManager()
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SettingsView()
                    .environmentObject(authStateManager)
                    .environmentObject(accentColorManager)
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
