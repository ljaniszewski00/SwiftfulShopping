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
    
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var productRecognizer = ProductRecognizer()
    @StateObject private var errorManager = ErrorManager.shared
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private let gridColumns = [GridItem(.flexible(), spacing: 0),
                               GridItem(.flexible(), spacing: 0),
                               GridItem(.flexible(), spacing: 0)]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    switch productRecognizer.sourceForImageRecognition {
                    case .camera:
                        CameraView(size: geometry.size)
                            .environmentObject(cameraViewModel)
                            .ignoresSafeArea()
                    case .photoLibrary:
                        VStack(alignment: .center, spacing: 30) {
                            Image(uiImage: productRecognizer.imageForRecognition)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button {
                                searchViewModel.shouldPresentImagePicker = true
                            } label: {
                                Text("Choose other image")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 15) {
                        Button {
                            withAnimation {
                                if productRecognizer.sourceForImageRecognition == .camera {
                                    cameraViewModel.stopCapturing()
                                }
                                productRecognizer.shouldPresentRecognizingAnimation = true
                                productRecognizer.recognizeProduct(pixelBuffer: cameraViewModel.pixelBuffer,
                                                                   errorManager: errorManager) {
                                }
                            }
                        } label: {
                            Text("Recognize")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                        }
                        .buttonStyle(CustomButton())
                        
                        Button {
                            withAnimation {
                                if productRecognizer.sourceForImageRecognition == .camera {
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
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                
                if productRecognizer.shouldPresentRecognizingAnimation {
                    buildRecognitionModal()
                }
            }
        }
        .navigationTitle("Recognize Product")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $productRecognizer.shouldPresentSheetWithResults, onDismiss: {
            if productRecognizer.sourceForImageRecognition == .camera {
                cameraViewModel.startCapturing()
            }
        }) {
            VStack(alignment: .center, spacing: 40) {
                VStack(alignment: .center, spacing: 20) {
                    Text("Recognition Results")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Text("Choose one of them to search for such product or try to recognize the product again")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 10) {
                    ForEach(productRecognizer.getFormattedResults(), id: \.self) { recognitionResult in
                        Button {
                            withAnimation {
                                exploreViewModel.searchProductsText = recognitionResult
                                productRecognizer.shouldPresentSheetWithResults = false
                                dismiss()
                            }
                        } label: {
                            Text(recognitionResult)
                                .padding(12)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .foregroundColor(colorScheme == .light ? Color(uiColor: .darkGray) : .white)
                        }
                    }
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                
                Spacer()
                
                Button {
                    withAnimation {
                        productRecognizer.shouldPresentSheetWithResults = false
                    }
                } label: {
                    Text("Try again")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
            }
            .padding()
            .padding(.top)
        }
        .sheet(isPresented: $searchViewModel.shouldPresentImagePicker) {
            ImagePicker(sourceType: .photoLibrary,
                        selectedImage: $productRecognizer.imageForRecognition)
            .onDisappear {
                productRecognizer.sourceForImageRecognition = .photoLibrary
            }
        }
        .onReceive(productRecognizer.$recognitionResult) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                productRecognizer.shouldPresentRecognizingAnimation = false
                if productRecognizer.recognitionResult != nil {
                    productRecognizer.shouldPresentSheetWithResults = true
                }
            }
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $searchViewModel.showLoadingModal))
        .onAppear {
            cameraViewModel.onAppear()
        }
    }
    
    @ViewBuilder func buildRecognitionModal() -> some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                LottieView(name: "recognizingObjects",
                           loopMode: .loop,
                           contentMode: .scaleAspectFill)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
                    .animation(.default)
                
                VStack(spacing: 15) {
                    Text("Recognizing Product")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    Text("Please wait a few seconds...")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                }
                .padding(.bottom)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
            }
            .frame(width:
                    ScreenBoundsSupplier.shared.getScreenWidth() * 0.8,
                   height:
                    ScreenBoundsSupplier.shared.getScreenHeight() * 0.4)
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