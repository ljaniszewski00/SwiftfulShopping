//
//  ContentView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    
    @StateObject private var authStateManager = AuthStateManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var contentViewModel = ContentViewModel()
    
    @State private var presentLoginView: Bool = false
    @State private var presentRegisterView: Bool = false
    
    var body: some View {
        if authStateManager.isLogged || authStateManager.isGuest {
            if contentViewModel.unlocked || !contentViewModel.biometricLock {
                HomeView()
                    .environmentObject(authStateManager)
                    .environmentObject(accentColorManager)
                    .transition(.slide)
            } else {
                VStack(spacing: 10) {
                    Spacer()
                    Text("Swiftful")
                        .font(.system(size: 45, weight: .heavy, design: .rounded))
                    Button(action: {
                        contentViewModel.authenticate()
                    }, label: {
                        Image(systemName: "faceid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.3,
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.25)
                    })
                    Text("Shopping")
                        .font(.system(size: 45, weight: .heavy, design: .rounded))
                    Spacer()
                }
                .padding()
            }
        } else {
            NavigationView {
                VStack {
                    Image(uiImage: UIImage(named: "AppIconImage")!)
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.95, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.4)
                            .foregroundColor(.white)
                        
                        VStack {
                            NavigationLink(isActive: $presentLoginView) {
                                LoginView()
                                    .environmentObject(authStateManager)
                            } label: {
                                Button("Login") {
                                    withAnimation() {
                                        UserDefaults.standard.set(false, forKey: "guest")
                                        presentLoginView = true
                                    }
                                }
                                .buttonStyle(CustomButton())
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom)
                            }
                            
                            NavigationLink(isActive: $presentRegisterView) {
                                RegisterView()
                                    .environmentObject(authStateManager)
                                    .environmentObject(locationManager)
                            } label: {
                                Button("Register") {
                                    withAnimation() {
                                        UserDefaults.standard.set(false, forKey: "guest")
                                        presentRegisterView = true
                                    }
                                }
                                .buttonStyle(CustomButton(buttonColor: .white, textColor: .accentColor, onlyStroke: true, strokeColor: .accentColor))
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .contentShape(Rectangle())
                                .padding(.bottom, 20)
                            }
                            
                            LabelledDivider(label: "or")
                            
                            Button("Explore as Guest") {
                                withAnimation() {
                                    authStateManager.didEnterAsGuest()
                                }
                            }
                            .buttonStyle(CustomButton(buttonColor: .gray))
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.9)
                            .contentShape(Rectangle())
                            .padding(.top, 20)
                        }
                    }
                    .position(x: ScreenBoundsSupplier.shared.getScreenWidth() * 0.5, y: ScreenBoundsSupplier.shared.getScreenHeight() * 0.3)
                }
                .onAppear {
                    if contentViewModel.biometricLock && !contentViewModel.shouldShowOnboarding {
                        contentViewModel.authenticate()
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .preferredColorScheme(.light)
                .background(Color.backgroundColor.ignoresSafeArea())
            }
            .navigationViewStyle(.stack)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let accentColorManager = AccentColorManager()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ContentView()
                    .environmentObject(accentColorManager)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
