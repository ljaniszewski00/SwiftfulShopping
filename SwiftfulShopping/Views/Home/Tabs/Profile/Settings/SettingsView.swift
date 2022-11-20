//
//  SettingsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI
import texterify_ios_sdk

struct SettingsView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    @StateObject private var networkNanager = NetworkManager.shared
    
    @State private var selection: String?
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    enum NavigationViewsNames: String, CaseIterable {
        case changeEmail
        case changePassword
        case deleteAccount
        
        init?(rawValue: String) {
            return nil
        }
        
        var rawValue: String {
            switch self {
            case .changeEmail:
                return TexterifyManager.localisedString(key: .settingsView(.navigationViewNameChangeEmail))
            case .changePassword:
                return TexterifyManager.localisedString(key: .settingsView(.navigationViewNameChangePassword))
            case .deleteAccount:
                return TexterifyManager.localisedString(key: .settingsView(.navigationViewNameDeleteAccount))
            }
        }
        
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.notifications)))
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                
                Toggle(isOn: $settingsViewModel.biometricLock, label: {
                    HStack(spacing: 20) {
                        Image(systemName: "faceid")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .frame(width: 30)
                        Text(TexterifyManager.localisedString(key: .settingsView(.biometrickLock)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.changeAccentColor)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.manageDarkMode)))
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
            } header: {
                Text(TexterifyManager.localisedString(key: .settingsView(.appSettingsSectionHeader)))
            } footer: {
                Text(TexterifyManager.localisedString(key: .settingsView(.appSettingsSectionFooter)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.changeEmail)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.changePassword)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.deleteAccount)))
                            .font(.ssButton).fontWeight(.regular)
                    }
                })
                .disabled(!networkNanager.isConnected)
            } header: {
                Text(TexterifyManager.localisedString(key: .settingsView(.accountActionsSectionHeader)))
            } footer: {
                Text(TexterifyManager.localisedString(key: .settingsView(.accountActionsSectionFooter)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.showOnboarding)))
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
                        Text(TexterifyManager.localisedString(key: .settingsView(.termsAndConditions)))
                            .font(.ssButton).fontWeight(.regular)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    }
                })
                
                HStack(spacing: 20) {
                    Image(systemName: "link.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .frame(width: 30)
                    Link(TexterifyManager.localisedString(key: .settingsView(.followMeOnGithub)),
                         destination: settingsViewModel.authorGitHubURL)
                        .foregroundColor(.accentColor)
                        .font(.ssCallout)
                }
            } header: {
                Text(TexterifyManager.localisedString(key: .settingsView(.additionalSectionHeader)))
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
        .navigationTitle(TexterifyManager.localisedString(key: .settingsView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.large)
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
        let accentColorManager = AccentColorManager()
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SettingsView()
                    .environmentObject(accentColorManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
