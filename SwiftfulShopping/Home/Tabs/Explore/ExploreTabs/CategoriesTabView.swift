//
//  CategoriesTabView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/07/2022.
//

import SwiftUI

struct CategoriesTabView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(Category.allCases, id: \.self) { category in
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            exploreViewModel.displayedCategory = category
                        }
                    } label: {
                        Text(category.rawValue)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton(textColor: .ssWhite, rightChevronNavigationImage: true))
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .contentShape(Rectangle())
                    .padding(.bottom, 20)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct CategoriesTabView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                CategoriesTabView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
