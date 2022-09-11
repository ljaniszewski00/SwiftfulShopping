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
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
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
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                
                Toggle(isOn: $settingsViewModel.biometricLock, label: {
                    HStack(spacing: 20) {
                        Image(systemName: "faceid")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Biometric Lock")
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                
                NavigationLink(destination: AccentColorChangeView()
                                                .environmentObject(settingsViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $settingsViewModel.shouldPresentAccentColorChangeView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "circle.hexagonpath.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Change Accent Color")
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                
                NavigationLink(destination: ColorSchemeChangeView()
                                                .environmentObject(settingsViewModel)
                                                .onAppear {
                                                    tabBarStateManager.hideTabBar()
                                                },
                               isActive: $settingsViewModel.shouldPresentColorSchemeChangeView,
                               label: {
                    HStack(spacing: 20) {
                        Image(systemName: "moon.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text("Manage Dark Mode")
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
            } header: {
                Text("App settings")
            } footer: {
                Text("Make shopping as easy as possible by personalizing the app to the maximum")
            }
            
            Section {
                NavigationLink(destination: ChangeEmailView()
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
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                .disabled(!networkNanager.isConnected)
                
                NavigationLink(destination: ChangePasswordView()
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
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                .disabled(!networkNanager.isConnected)
                
                NavigationLink(destination: DeleteAccountView()
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
                            .font(.ssButton).fontWeight(.regular)
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
                            .font(.ssButton).fontWeight(.regular)
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
                            .font(.ssButton).fontWeight(.regular)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    }
                })
                
                HStack(spacing: 20) {
                    Image(systemName: "link.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .frame(width: 30)
                    Text("Follow me on GitHub:")
                        .font(.ssButton).fontWeight(.regular)
                        .fixedSize(horizontal: true, vertical: false)
                    Link("ljaniszewski00", destination: settingsViewModel.authorGitHubURL)
                        .foregroundColor(.accentColor)
                        .font(.ssCallout)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } header: {
                Text("Additional")
            }
            
            VStack(alignment: .center, spacing: 10) {
                Text(UIApplication.versionBuild())
                    .font(.ssTitle3)
                    .foregroundColor(.ssDarkGray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .listRowInsets(EdgeInsets())
            .background(Color(UIColor.systemGroupedBackground))
        }
        .navigationTitle("Settings")
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
