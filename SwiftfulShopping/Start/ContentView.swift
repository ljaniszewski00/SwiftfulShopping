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
    @StateObject var errorManager = ErrorManager.shared
    
    var body: some View {
        if authStateManager.isLogged && !authStateManager.isGuest {
            if contentViewModel.unlocked || !contentViewModel.biometricLock {
                HomeView()
                    .environmentObject(authStateManager)
                    .environmentObject(accentColorManager)
                    .transition(.slide)
            } else {
                VStack(spacing: 10) {
                    Image("AppLogoHorizontal")
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                }
                .padding()
                .modifier(ErrorModal(isPresented: $errorManager.showErrorModal,
                                     customError: errorManager.customError ?? ErrorManager.unknownError))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        contentViewModel.authenticate()
                    }
                }
                .onChange(of: contentViewModel.authenticationError?.localizedDescription) { error in
                    errorManager.generateCustomError(errorType: .biometricRecognitionError,
                                                     additionalErrorDescription: error)
                }
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
