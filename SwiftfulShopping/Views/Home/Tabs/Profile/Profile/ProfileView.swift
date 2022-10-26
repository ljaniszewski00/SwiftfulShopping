//
//  ProfileView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 04/06/2022.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var networkNanager = NetworkManager.shared
    @StateObject private var firebaseAuthManager = FirebaseAuthManager.client
    @StateObject var errorManager = ErrorManager.shared
    
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
    
    private var navigationIconsForNames: [NavigationViewsNames: String] = [.orders: "cart.fill",
                                                                   .returns: "return",
                                                                   .personalInfo: "person.fill",
                                                                   .paymentDetails: "creditcard.fill",
                                                                   .help: "questionmark.circle.fill"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                PullToRefresh(coordinateSpace: .named("PullToRefresh")) {
                    profileViewModel.fetchProfile { _ in }
                }
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hello, \(profileViewModel.profile?.fullName.components(separatedBy: " ").first! ?? "")!")
                                .font(.ssTitle2)
                            Text("We are happy to see you again.")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
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
                                    .font(.ssButton)
                            }
                        }
                        .padding(.trailing, 20)
                        .onTapGesture {
                            shouldPresentAddActionSheet = true
                        }
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .center, spacing: 20) {
                        ForEach(NavigationViewsNames.allCases, id: \.self) { navigationViewName in
                            HStack {
                                Spacer()
                                Button {
                                    selection = navigationViewName.rawValue
                                } label: {
                                    HStack(spacing: 20) {
                                        Image(systemName: navigationIconsForNames[navigationViewName]!)
                                        Text(navigationViewName.rawValue)
                                            .font(.ssButton)
                                    }
                                    
                                }
                                .buttonStyle(CustomButton(textColor: .ssWhite, rightChevronNavigationImage: true))
                                .contentShape(Rectangle())
                                .if(navigationViewName == .help) {
                                    $0
                                        .disabled(!networkNanager.isConnected)
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 20) {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    profileViewModel.shouldPresentSettingsView = true
                                }
                            } label: {
                                HStack(spacing: 20) {
                                    Image(systemName: "gearshape.fill")
                                    Text("Settings")
                                        .font(.ssButton)
                                }
                            }
                            .buttonStyle(CustomButton(textColor: .ssWhite, rightChevronNavigationImage: true))
                            .contentShape(Rectangle())
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Button {
                                profileViewModel.signOut { result in
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(let error):
                                        ErrorManager.shared.generateCustomError(errorType: .signOutError,
                                                                                additionalErrorDescription: error.localizedDescription)
                                    }
                                }
                            } label: {
                                Text("Logout")
                                    .font(.ssButton)
                            }
                            .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor, imageName: "rectangle.portrait.and.arrow.right", imageColor: .accentColor))
                            .contentShape(Rectangle())
                            Spacer()
                        }
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 90)
                    
                    NavigationLink(destination: OrdersView(),
                                   tag: "Orders",
                                   selection: $selection) { EmptyView() }
                        .isDetailLink(false)
                    
                    NavigationLink(destination: ReturnsView(),
                                   tag: "Returns",
                                   selection: $selection) { EmptyView() }
                    
                    NavigationLink(destination: PersonalInfoView(),
                                   tag: "Personal Info",
                                   selection: $selection) { EmptyView() }
                    
                    NavigationLink(destination: PaymentDetailsView(),
                                   tag: "Payment Details",
                                   selection: $selection) { EmptyView() }
                    
                    NavigationLink(destination: HelpView(),
                                   tag: "Help",
                                   selection: $selection) { EmptyView() }
                    
                    NavigationLink(destination: SettingsView(),
                                   isActive: $profileViewModel.shouldPresentSettingsView,
                                   label: { EmptyView() })
                }
                .padding()
            }
            .coordinateSpace(name: "PullToRefresh")
            .modifier(LoadingIndicatorModal(isPresented:
                                                $profileViewModel.showLoadingModal))
            .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                 customError: errorManager.customError ?? ErrorManager.unknownError))
            .navigationTitle("Profile")
            .navigationBarHidden(true)
            .sheet(isPresented: $shouldPresentImagePicker) {
                ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedImage: $profileViewModel.image)
                    .onDisappear {
                        profileViewModel.changePhoto { result in
                            switch result {
                            case .success:
                                break
                            case .failure(let error):
                                errorManager.generateCustomError(errorType: .changePhotoError,
                                                                 additionalErrorDescription: error.localizedDescription)
                            }
                        }
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
        .environmentObject(firebaseAuthManager)
        .environmentObject(accentColorManager)
        .environmentObject(tabBarStateManager)
        .environmentObject(profileViewModel)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let accentColorManager = AccentColorManager()
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProfileView()
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
