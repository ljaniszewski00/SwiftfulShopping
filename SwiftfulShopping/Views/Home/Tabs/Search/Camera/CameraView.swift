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
        view.layer.addSublayer(setupCapturePreview())
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    private func setupCapturePreview() -> AVCaptureVideoPreviewLayer {
        let capturePreview = AVCaptureVideoPreviewLayer(session: cameraViewModel.captureSession)
        capturePreview.frame.size = size
        capturePreview.videoGravity = .resizeAspectFill
        return capturePreview
    }
}
