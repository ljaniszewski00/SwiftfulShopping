//
//  CustomTabBarContainerView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/11/2022.
//

import SwiftUI
import texterify_ios_sdk

struct CustomTabBarContainerView<Content: View>: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>,
         @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(selection: $selection,
                             tabs: tabs,
                             localSelection: selection)
            .environmentObject(tabBarStateManager)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .explore, .favorites, .cart, .search, .profile
    ]
    
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                VStack {
                    Spacer()
                    CustomTabBarContainerView(selection: .constant(tabs.first!)) {
                        Color.red
                    }
                    .environmentObject(tabBarStateManager)
                }
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
