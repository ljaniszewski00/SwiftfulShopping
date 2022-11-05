//
//  NotificationsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct NotificationsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            LottieView(name: LottieAssetsNames.maintenance,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit)
            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.8,
                   height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.4)
            Text(TexterifyManager.localisedString(key: .notificationsView(.thisPageIsUnderConstruction)))
                .font(.ssTitle1)
            Spacer()
        }
        .padding(.top, 50)
        .navigationTitle(TexterifyManager.localisedString(key: .notificationsView(.navigationTitle)))
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                NotificationsView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
