//
//  CameraView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/08/2022.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @EnvironmentObject var cameraViewModel: CameraViewModel
    
    var size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        cameraViewModel.capturePreview = AVCaptureVideoPreviewLayer(session: cameraViewModel.captureSession)
        cameraViewModel.capturePreview.frame.size = size
        
        cameraViewModel.capturePreview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(cameraViewModel.capturePreview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
