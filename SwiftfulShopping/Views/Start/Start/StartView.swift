//
//  StartView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var startViewModel: StartViewModel = StartViewModel()
    
    @StateObject private var firebaseAuthManager = FirebaseAuthManager.client
    @StateObject private var locationManager = LocationManager()
    
    @StateObject private var exploreViewModel = ExploreViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    
    @StateObject var errorManager = ErrorManager.shared
    
    var body: some View {
        Group {
            if firebaseAuthManager.isLogged {
                // User is logged
                Group {
                    if startViewModel.unlockedBiometric {
                        // User is logged and unlocked biometric
                        if startViewModel.canPresentHomeView {
                            // User is logged, unlocked biometric and data has been fetched
                            HomeView()
                                .environmentObject(firebaseAuthManager)
                                .environmentObject(accentColorManager)
                                .environmentObject(exploreViewModel)
                                .environmentObject(profileViewModel)
                                .environmentObject(cartViewModel)
                                .environmentObject(favoritesViewModel)
                                .environmentObject(searchViewModel)
                        } else {
                            // User is logged, unlocked biometric and data has not been fetched
                            splashScreen
                        }
                    } else {
                        // User is logged and biometric is not unlocked
                        biometricUnlockScreen
                    }
                }
                .onAppear {
                    onAppear {
                        startViewModel.dataFetched = true
                    }
                }
            } else {
                // User is not logged
                LoginView()
                    .environmentObject(firebaseAuthManager)
                    .environmentObject(locationManager)
                    .environmentObject(startViewModel)
            }
        }
    }
    
    var splashScreen: some View {
        VStack {
            if colorScheme == .light {
                Image(AssetsNames.logoHorizontalGray)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                           height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
            } else if colorScheme == .dark {
                Image(AssetsNames.logoHorizontalWhite)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                           height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
            }
            
            Spacer()
            
            LottieView(name: LottieAssetsNames.cartSplashScreen,
                       loopMode: .loop,
                       contentMode: .scaleAspectFill)
            
            Spacer()
        }
        .background {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
        }
    }
    
    var biometricUnlockScreen: some View {
        VStack(spacing: 10) {
            if colorScheme == .light {
                Image(AssetsNames.logoVerticalGray)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                           height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
            } else if colorScheme == .dark {
                Image(AssetsNames.logoVerticalWhite)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                startViewModel.authenticate()
            }
        }
        .onChange(of: startViewModel.authenticationError?.localizedDescription) { error in
            errorManager.generateCustomError(errorType: .biometricRecognitionError,
                                             additionalErrorDescription: error)
        }
    }
    
    func onAppear(completion: @escaping (() -> ())) {
        profileViewModel.fetchData { result in
            switch result {
            case .success:
                exploreViewModel.fetchData {
                    cartViewModel.onAppear()
                    searchViewModel.onAppear()
                    favoritesViewModel.fetchFavorites()
                    
                    startViewModel.dataFetched = true
                    completion()
                }
            case .failure(let error):
                profileViewModel.signOut { result in
                    switch result {
                    case .success:
                        break
                    case .failure(_):
                        errorManager.generateCustomError(errorType: .dataFetchError,
                                                         additionalErrorDescription: error.localizedDescription)
                    }
                    completion()
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let accentColorManager: AccentColorManager = AccentColorManager()
        
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                SplashScreenView()
                    .environmentObject(accentColorManager)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
