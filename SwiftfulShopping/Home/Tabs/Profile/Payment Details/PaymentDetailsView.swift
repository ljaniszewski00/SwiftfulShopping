//
//  PaymentDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct PaymentDetailsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                VStack {
                    HStack {
                        Text("VISA")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.all, 20)
                .frame(width: 350, height: 210)
                .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color(uiColor: UIColor(rgb: 0x7CEA9C))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                Spacer()
            }
        }
        .navigationTitle("Payment Details")
        .scrollOnOverflow(showScrollIndicators: false)
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                PaymentDetailsView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
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
