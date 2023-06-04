//
//  OnboardingView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 29/11/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    
    @StateObject private var errorManager: ErrorManager = ErrorManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                TabView {
                    ForEach(onboardingViewModel.onboardingTilesNumbersRange, id: \.self) { number in
                        if let photoModel = onboardingViewModel.onboardingTilesPhotosModels[optional: number],
                           let heading = onboardingViewModel.onboardingTilesHeadings[number],
                           let description = onboardingViewModel.onboardingTilesDescriptions[number] {
                            OnboardingTile(image: photoModel.image,
                                           heading: heading,
                                           description: description)
                        }
                    }
                }
                .tabViewStyle(.page)
            }
            
            HStack {
                Button {
                    onboardingViewModel.shouldShowOnboarding = false
                    dismiss()
                } label: {
                    Text(TexterifyManager.localisedString(key: .onboardingView(.dismissButton)))
                }
                .buttonStyle(CustomButton())
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
        }
        .modifier(LoadingIndicatorModal(isPresented: $onboardingViewModel.showLoadingModal))
        .onChange(of: onboardingViewModel.shouldDismiss) {
            if $0 {
                dismiss()
            }
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
}

extension OnboardingView {
    
    struct OnboardingTile: View {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        let image: UIImage
        let heading: String
        let description: String
        
        var body: some View {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical)
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(.accentColor)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text(heading)
                                .font(.ssTitle2)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(description)
                                .font(.ssTitle3)
                                .fontWeight(.regular)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .multilineTextAlignment(.leading)
                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                    .padding()
                }
                .frame(height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.23)
            }
        }
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
