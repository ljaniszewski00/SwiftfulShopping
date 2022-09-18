//
//  SplashScreenView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var splashScreenViewModel: SplashScreenViewModel = SplashScreenViewModel()
    
    var body: some View {
        Group {
            if splashScreenViewModel.shouldPresentContentView {
                ContentView()
                    .environmentObject(accentColorManager)
            } else {
                VStack {
                    if colorScheme == .light {
                        Image("SwiftfulShoppingLogo - horizontal (gray)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                    } else if colorScheme == .dark {
                        Image("SwiftfulShoppingLogo - horizontal (white)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                    }
                    
                    Spacer()
                    
                    LottieView(name: "cartSplashScreen",
                               loopMode: .loop,
                               contentMode: .scaleAspectFill)
                    
                    Spacer()
                }
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .ignoresSafeArea()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        splashScreenViewModel.shouldPresentContentView = true
                    }
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
