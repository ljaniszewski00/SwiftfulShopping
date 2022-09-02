//
//  SplashScreenView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject private var accentColorManager: AccentColorManager
    
    @StateObject private var splashScreenViewModel: SplashScreenViewModel = SplashScreenViewModel()
    
    var body: some View {
        Group {
            if splashScreenViewModel.shouldPresentContentView {
                ContentView()
                    .environmentObject(accentColorManager)
            } else {
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Text("Swiftful")
                            .font(.system(size: 45, weight: .heavy, design: .rounded))
                            .offset(y: 200)
                        LottieView(name: "cartSplashScreen",
                                   loopMode: .loop,
                                   contentMode: .scaleAspectFill)
                        Text("Shopping")
                            .font(.system(size: 45, weight: .heavy, design: .rounded))
                            .offset(y: -200)
                    }
                    Spacer()
                }
                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                        splashScreenViewModel.shouldPresentContentView = true
//                    }
                    splashScreenViewModel.shouldPresentContentView = true
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
