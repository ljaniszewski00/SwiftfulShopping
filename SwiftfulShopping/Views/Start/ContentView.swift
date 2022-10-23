//
//  ContentView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var firebaseAuthManager = FirebaseAuthManager.client
    @StateObject private var locationManager = LocationManager()
    @StateObject private var contentViewModel = ContentViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    var body: some View {
        if firebaseAuthManager.isLogged {
            if contentViewModel.unlocked || !contentViewModel.biometricLock {
                HomeView()
                    .environmentObject(firebaseAuthManager)
                    .environmentObject(accentColorManager)
                    .transition(.slide)
            } else {
                VStack(spacing: 10) {
                    if colorScheme == .light {
                        Image("SwiftfulShoppingLogo - vertical (gray)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                    } else if colorScheme == .dark {
                        Image("SwiftfulShoppingLogo - vertical (white)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                    }
                    
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
                .environmentObject(firebaseAuthManager)
                .environmentObject(locationManager)
                .environmentObject(contentViewModel)
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
