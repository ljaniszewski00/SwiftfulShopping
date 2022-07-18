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
    
    @State private var selection: String?
        
    @State private var shouldPresentAddActionSheet = false
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentCamera = false
    
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
                                Text("Please register down below.")
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
                                Image(uiImage: profileViewModel.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.2)
                                
                                // TODO: Add NavigationLink
                                Button {
                                    shouldPresentAddActionSheet = true
                                } label: {
                                    Text("Change photo")
                                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                                }
                            }
                            .padding(.trailing, 20)
                            .onTapGesture {
                                shouldPresentAddActionSheet = true
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                        
                        VStack(alignment: .center) {
                            ForEach(NavigationViewsNames.allCases, id: \.self) { navigationViewName in
                                HStack {
                                    Spacer()
                                    Button {
                                        selection = navigationViewName.rawValue
                                    } label: {
                                        Text(navigationViewName.rawValue)
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                    }
                                    .buttonStyle(CustomButton(textColor: .white, rightChevronNavigationImage: true))
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .contentShape(Rectangle())
                                    .padding(.bottom, 20)
                                    Spacer()
                                }
                            }
                        }
                        
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation {
                                        authStateManager.logoutCompletely()
                                    }
                                } label: {
                                    Text("Logout")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }
                                .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, imageName: "rectangle.portrait.and.arrow.right", imageColor: .accentColor))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.top, 50)
                                .padding(.bottom, 20)
                                Spacer()
                            }
                        }
                        
                        NavigationLink(destination: OrdersView()
                                                        .environmentObject(authStateManager)
                                                        .environmentObject(tabBarStateManager)
                                                        .environmentObject(profileViewModel),
                                       tag: "Orders",
                                       selection: $selection) { EmptyView() }
                        
                        NavigationLink(destination: ReturnsView()
                                                        .environmentObject(authStateManager)
                                                        .environmentObject(tabBarStateManager)
                                                        .environmentObject(profileViewModel),
                                       tag: "Returns",
                                       selection: $selection) { EmptyView() }
                        
                        NavigationLink(destination: PersonalInfoView()
                                                        .environmentObject(authStateManager)
                                                        .environmentObject(tabBarStateManager)
                                                        .environmentObject(profileViewModel),
                                       tag: "Personal Info",
                                       selection: $selection) { EmptyView() }
                        
                        NavigationLink(destination: PaymentDetailsView()
                                                        .environmentObject(authStateManager)
                                                        .environmentObject(tabBarStateManager)
                                                        .environmentObject(profileViewModel),
                                       tag: "Payment Details",
                                       selection: $selection) { EmptyView() }
                        
                        NavigationLink(destination: HelpView()
                                                        .environmentObject(authStateManager)
                                                        .environmentObject(tabBarStateManager)
                                                        .environmentObject(profileViewModel),
                                       tag: "Help",
                                       selection: $selection) { EmptyView() }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
            .sheet(isPresented: $shouldPresentImagePicker) {
                ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedImage: $profileViewModel.image)
                    .onDisappear {
                        profileViewModel.uploadPhoto()
                    }
            }
            .actionSheet(isPresented: $shouldPresentAddActionSheet) {
                ActionSheet(title: Text("Change Photo"), message: nil, buttons: [
                    .default(Text("Take Photo"), action: {
                         self.shouldPresentImagePicker = true
                         self.shouldPresentCamera = true
                     }),
                    .default(Text("Choose Photo"), action: {
                         self.shouldPresentImagePicker = true
                         self.shouldPresentCamera = false
                     }),
                    .cancel()
                ])
            }
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
