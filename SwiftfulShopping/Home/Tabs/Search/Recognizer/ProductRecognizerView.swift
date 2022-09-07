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
                                Text("Choose other image")
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
                            Text("Recognize")
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
                            Text(productRecognizer.sourceForImageRecognition == .camera ? "Use Photo Library" : "Use Camera")
                                .font(.ssButton)
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
                            Text("No products found!")
                                .font(.ssTitle2)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Try recognizing the product again by clicking button down below.")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                } else {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Recognition Results")
                            .font(.ssTitle1)
                        
                        Text("Choose one of the products listed below if it is what you wanted. Otherwise, try recognizing the product again.")
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    List {
                        ForEach(exploreViewModel.getProductsListFor(recognitionResults: productRecognizer.getFormattedResults()), id: \.self) { product in
                            Button {
                                searchViewModel.choosenProduct = product
                                productRecognizer.shouldPresentSheetWithResults = false
                                searchViewModel.shouldPresentProductRecognizerView = false
                                searchViewModel.shouldPresentProductDetailsView = true
                            } label: {
                                BasicProductTile(product: product)
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
                    Text("Try again")
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
            Color.ssBlack
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
                        .font(.ssTitle3)
                    
                    Text("Please wait a few seconds...")
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
