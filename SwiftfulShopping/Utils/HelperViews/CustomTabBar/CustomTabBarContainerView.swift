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
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    
    var shoppingCartProductsNumber: Int = 0
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>,
         shoppingCartProductsNumber: Int = 0,
         @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.shoppingCartProductsNumber = shoppingCartProductsNumber
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(selection: $selection,
                             localSelection: selection,
                             tabs: tabs,
                             shoppingCartProductsNumber: shoppingCartProductsNumber)
            .environmentObject(tabBarStateManager)
            .environmentObject(exploreViewModel)
            .measureSize(size: $tabBarStateManager.tabBarSize)
            .onChange(of: tabBarStateManager.tabBarSize) { newSize in
                tabBarStateManager.changeTabBarValuesFor(tabBarNewSize: newSize)
            }
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
        let exploreViewModel = ExploreViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                VStack {
                    Spacer()
                    CustomTabBarContainerView(selection: .constant(tabs.first!)) {
                        Color.red
                    }
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                }
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
