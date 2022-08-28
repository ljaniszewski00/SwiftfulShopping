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
    
    var body: some View {
        if authStateManager.isLogged && !authStateManager.isGuest {
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
            LoginView()
                .environmentObject(authStateManager)
                .environmentObject(locationManager)
                .environmentObject(contentViewModel)
                .onAppear {
                    authStateManager.isLogged = true
                    authStateManager.isGuest = false
                }
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
