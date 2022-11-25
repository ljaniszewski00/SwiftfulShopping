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
import texterify_ios_sdk
import Stripe
import StripePaymentSheet

@main
struct SwiftlyShoppingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage(AppStorageConstants.appThemeSetting) var appThemeSetting = Appearance.system
    
    @StateObject private var accentColorManager = AccentColorManager()
    
    var body: some Scene {
        WindowGroup {
            StartView()
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
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // MARK: Initializing Stripe
        if let stripeAPIKey = StripeConstants.stripeAPIKey {
            StripeAPI.defaultPublishableKey = stripeAPIKey
            var configuration = PaymentSheet.Configuration()
            configuration.returnURL = "SwiftfulShopping://stripe-redirect"
        } else {
            print("Could not initialize Stripe, no API Key found.")
        }
        
        // MARK: Initializing Firebase
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // MARK: Initializing Texterify
        let localizer = TexterifyManager(baseUrl: "https://app.texterify.com",
                                         projectId: "1aaa5a7a-d768-47e8-b873-d741f5ac157a",
                                         exportConfigId: "e5cd9480-edad-41b7-9576-ca6b66cd0c49")
        localizer.getUpdatedStrings { _ in }
        
        return true
    }
    
    // This method handles opening custom URL schemes (for example, "your-app://stripe-redirect")
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
    }

    // This method handles opening universal link URLs (for example, "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = StripeAPI.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a Stripe url – handle the URL normally as you would
                }
            }
        }
        return false
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
