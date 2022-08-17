//
//  ProductIdentifierView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/08/2022.
//

import SwiftUI
import AVKit

struct ProductRecognizerView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 40) {
                switch searchViewModel.sourceForImageRecognition {
                case .camera:
                    GeometryReader { proxy in
                        
                    }
                case .photoLibrary:
                    if let imageForRecognition = searchViewModel.imageForRecognition {
                        Image(uiImage: imageForRecognition)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    Button {
                        withAnimation {
                            searchViewModel.recognizeImage(errorManager: errorManager)
                        }
                    } label: {
                        Text("Recognize")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton())
                    
                    Button {
                        withAnimation {
                            searchViewModel.shouldPresentImagePicker = true
                        }
                    } label: {
                        Text("Use Photo Library")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                }
                .padding()
            }
        }
        .navigationTitle("Recognize Product")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $searchViewModel.shouldPresentImagePicker) {
            ImagePicker(sourceType: .photoLibrary,
                        selectedImage: $searchViewModel.imageForRecognition)
                .onDisappear {
                    searchViewModel.uploadNewImageForRecognition()
                }
        }
        .onReceive(searchViewModel.$recognitionResult) { _ in
            if let recognitionResult = searchViewModel.recognitionResult {
                exploreViewModel.searchProductsText = recognitionResult
                dismiss()
            }
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $searchViewModel.showLoadingModal))
        .modifier(ErrorModal(isPresented: $errorManager.showErrorModal, customError: errorManager.customError ?? ErrorManager.unknownError))
        .onAppear {
            cameraViewModel.onAppear()
        }
    }
}

struct ProductIdentifierView_Previews: PreviewProvider {
    static var previews: some View {
        let exploreViewModel = ExploreViewModel()
        let searchViewModel = SearchViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                ProductRecognizerView()
                    .environmentObject(exploreViewModel)
                    .environmentObject(searchViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
