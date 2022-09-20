//
//  SwiftfulShoppingApp.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import FacebookCore

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
        
        //Initializing Firebase
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

class SceneDelegate: NSObject, UISceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
                return
            }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
