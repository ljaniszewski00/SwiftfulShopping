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
    
    @StateObject private var errorManager: ErrorManager = ErrorManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack() {
                TabView {
                    ForEach(onboardingViewModel.onboardingTilesNumbersRange, id: \.self) { number in
                        if let photo = onboardingViewModel.onboardingTilesPhotos[number],
                           let heading = onboardingViewModel.onboardingTilesHeadings[number],
                           let description = onboardingViewModel.onboardingTilesDescriptions[number] {
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFill()
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.accentColor)
                                
                                VStack(spacing: 15) {
                                    Text(heading)
                                        .font(.ssTitle1)
                                    
                                    HStack {
                                        Text(description)
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
        .onAppear {
            onboardingViewModel.getOnboardingTilesPhotos { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    errorManager.generateCustomError(errorType: .dataFetchError,
                                                     additionalErrorDescription: error.localizedDescription)
                }
            }
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
