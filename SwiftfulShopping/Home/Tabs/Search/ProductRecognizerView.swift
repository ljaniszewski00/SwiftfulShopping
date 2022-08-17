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
    @StateObject private var productRecognizer = ProductRecognizer()
    @StateObject private var errorManager = ErrorManager.shared
    
    var body: some View {
        VStack(alignment: .center) {
            switch productRecognizer.sourceForImageRecognition {
            case .camera:
                GeometryReader { geometry in
                    CameraView(size: geometry.size)
                        .environmentObject(cameraViewModel)
                }
            case .photoLibrary:
                Image(uiImage: productRecognizer.imageForRecognition)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 15) {
                Button {
                    withAnimation {
                        productRecognizer.recognizeProduct(pixelBuffer: cameraViewModel.pixelBuffer,
                                                           errorManager: errorManager)
                    }
                } label: {
                    Text("Recognize")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton())
                
                Button {
                    withAnimation {
                        if productRecognizer.sourceForImageRecognition == .camera {
                            productRecognizer.sourceForImageRecognition = .photoLibrary
                            cameraViewModel.stopCapturing()
                            searchViewModel.shouldPresentImagePicker = true
                        } else {
                            productRecognizer.sourceForImageRecognition = .camera
                            searchViewModel.shouldPresentImagePicker = false
                            cameraViewModel.startCapturing()
                        }
                    }
                } label: {
                    Text(productRecognizer.sourceForImageRecognition == .camera ? "Use Photo Library" : "Use Camera")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
            }
            .padding()
        }
        .navigationTitle("Recognize Product")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $searchViewModel.shouldPresentImagePicker) {
            ImagePicker(sourceType: .photoLibrary,
                        selectedImage: $productRecognizer.imageForRecognition)
        }
        .onReceive(productRecognizer.$recognitionResult) { _ in
            if let recognitionResult = productRecognizer.recognitionResult {
                exploreViewModel.searchProductsText = recognitionResult
                dismiss()
            }
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $searchViewModel.showLoadingModal))
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
