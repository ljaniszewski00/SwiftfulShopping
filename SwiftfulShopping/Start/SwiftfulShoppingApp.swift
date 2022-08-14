//
//  SwiftfulShoppingApp.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

@main
struct SwiftlyShoppingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("appThemeSetting") var appThemeSetting = Appearance.system
    
    @StateObject private var accentColorManager = AccentColorManager()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .accentColor(accentColorManager.ownColorSet ? accentColorManager.ownColor : Color(uiColor: accentColorManager.accentColor.rawValue))
                .modifier(DarkModeViewModifier())
                .environmentObject(accentColorManager)
                .onAppear {
                    accentColorManager.fetchColors()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
}
