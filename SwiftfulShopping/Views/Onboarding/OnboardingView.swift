//
//  OnboardingView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/11/2022.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @StateObject private var onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack() {
                TabView {
                    ForEach(1...5, id: \.self) { number in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.accentColor)
                            
                            VStack(spacing: 15) {
                                Text("AAA")
                                    .font(.ssTitle1)
                                
                                HStack {
                                    Text("AAA")
                                        .font(.ssTitle3)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                            }
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                            .padding()
                        }
                        .frame(height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.2)
                    }
                }
                .tabViewStyle(.page)
            }
            
            HStack {
                Button {
                    onboardingViewModel.shouldShowOnboarding = false
                } label: {
                    Text("Dismiss")
                }
                .buttonStyle(CustomButton())
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
        }
    }
    
    @ViewBuilder func buildOnboardingPage(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OnboardingView()
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
