//
//  CustomTabBarView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/11/2022.
//

import SwiftUI
import texterify_ios_sdk

struct CustomTabBarView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem
    let tabs: [TabBarItem]
    var shoppingCartProductsNumber: Int = 0
    
    var body: some View {
        if !tabBarStateManager.isHidden {
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        switchToTab(tab: tab)
                    } label: {
                        buildTabView(tab: tab)
                    }
                }
            }
            .padding(6)
            .padding([.horizontal, .bottom])
            .background (
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .onChange(of: selection) { value in
                withAnimation(.easeInOut) {
                    localSelection = selection
                }
            }
            .animation(.default)
            .transition(.move(edge: .bottom))
            .zIndex(1)
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .explore, .favorites, .cart, .search, .profile
    ]
    
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                VStack {
                    Spacer()
                    CustomTabBarView(selection: .constant(tabs.first!),
                                     localSelection: tabs.first!,
                                     tabs: tabs)
                    .environmentObject(tabBarStateManager)
                }
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}

extension CustomTabBarView {
    private func buildTabView(tab: TabBarItem) -> some View {
        VStack(spacing: 5) {
            Image(systemName: tab.iconName)
                .symbolVariant(.fill)
                .font(.body.bold())
            Text(tab.title)
                .font(.ssCaption1)
                .lineLimit(1)
        }
        .foregroundColor(localSelection == tab ? .accentColor : .ssDarkGray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .if(tab == .cart && shoppingCartProductsNumber > 0) {
            $0
                .overlay(
                    Text(String(shoppingCartProductsNumber))
                        .font(.ssCaption1)
                        .foregroundColor(.ssWhite)
                        .padding(.all, shoppingCartProductsNumber >= 10 ? 2 : 5)
                        .background {
                            Circle()
                                .foregroundColor(.red)
                        }
                        .offset(x: 17, y: -22)
                )
        }
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}
