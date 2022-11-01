//
//  ProductIdentifierView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/08/2022.
//

import SwiftUI
import AVKit
import texterify_ios_sdk

struct ProductRecognizerView: View {
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel
    
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var productRecognizer = ProductRecognizer()
    @StateObject private var errorManager = ErrorManager.shared
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
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
                                Text(TexterifyManager.localisedString(key: .productRecognizerView(.chooseOtherImage)))
                                    .font(.ssTitle3)
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
                            Text(TexterifyManager.localisedString(key: .productRecognizerView(.recognizeButton)))
                                .font(.ssButton)
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
                            Text(productRecognizer.sourceForImageRecognition == .camera ? TexterifyManager.localisedString(key: .productRecognizerView(.usePhotoLibraryButton)) :TexterifyManager.localisedString(key: .productRecognizerView(.useCameraButton)))
                                .font(.ssButton)
                        }
                        .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding(.horizontal)
                }
                
                if productRecognizer.shouldPresentRecognizingAnimation {
                    buildRecognitionModal()
                }
            }
        }
        .navigationTitle(TexterifyManager.localisedString(key: .productRecognizerView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .sheet(isPresented: $productRecognizer.shouldPresentSheetWithResults, onDismiss: {
            if productRecognizer.sourceForImageRecognition == .camera {
                cameraViewModel.startCapturing()
            }
        }) {
            VStack(alignment: .center, spacing: 20) {
                if exploreViewModel.getProductsListFor(recognitionResults: productRecognizer.getFormattedResults()).isEmpty {
                    VStack {
                        LottieView(name: "searchNoResults",
                                   loopMode: .loop,
                                   contentMode: .scaleAspectFill)
                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth(),
                               height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.5)
                        VStack(spacing: 20) {
                            Text(TexterifyManager.localisedString(key: .productRecognizerView(.noProductsFound)))
                                .font(.ssTitle2)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(TexterifyManager.localisedString(key: .productRecognizerView(.tryRecognizingTheProductAgain)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                } else {
                    VStack(alignment: .center, spacing: 20) {
                        Text(TexterifyManager.localisedString(key: .productRecognizerView(.recognitionResults)))
                            .font(.ssTitle1)
                        
                        Text(TexterifyManager.localisedString(key: .productRecognizerView(.chooseOneOfTheProducts)))
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    List {
                        ForEach(exploreViewModel.getProductsListFor(recognitionResults: productRecognizer.getFormattedResults()), id: \.self) { product in
                            Button {
                                DispatchQueue.main.async {
                                    searchViewModel.choosenProduct = product
                                    productRecognizer.shouldPresentSheetWithResults = false
                                    searchViewModel.shouldPresentProductRecognizerView = false
                                    searchViewModel.shouldPresentProductDetailsView = true
                                }
                            } label: {
                                BasicProductTile(product: product, includeRateButton: false)
                            }
                        }
                    }
                    .listStyle(.grouped)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        productRecognizer.shouldPresentSheetWithResults = false
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .productRecognizerView(.tryAgainButton)))
                        .font(.ssButton)
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
                    Text(TexterifyManager.localisedString(key: .productRecognizerView(.recognizingProductModalLabel)))
                        .font(.ssTitle3)
                    
                    Text(TexterifyManager.localisedString(key: .productRecognizerView(.pleaseWaitAFewSecondsModalLabel)))
                        .font(.ssCallout)
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
