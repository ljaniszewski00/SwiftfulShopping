//
//  CameraModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/08/2022.
//

import Foundation
import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var captureSession = AVCaptureSession()
    @Published var captureOutput = AVCaptureVideoDataOutput()
    @Published var capturePreview: AVCaptureVideoPreviewLayer!
    
    func onAppear() {
        checkPermission { [weak self] permissionGranted in
            if permissionGranted {
                self?.setupAV()
            }
        }
    }
    
    func checkPermission(completion: @escaping ((Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return completion(true)
        case .denied:
            return completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                return completion(status)
            }
        case .restricted:
            return completion(false)
        @unknown default:
            return completion(false)
        }
    }
    
    func setupAV() {
        do {
            captureSession.beginConfiguration()
            if let captureDevice = AVCaptureDevice.default(for: .video) {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
                
                if captureSession.canAddOutput(captureOutput) {
                    captureSession.addOutput(captureOutput)
                }
                
                captureSession.commitConfiguration()
            }
        } catch(let error) {
//            generateError(errorManager: errorManager,
//                          additionalErrorDescription: error.localizedDescription)
        }
        
//        if let captureDevice = AVCaptureDevice.default(for: .video) {
//            if let input = try? AVCaptureDeviceInput(device: captureDevice) {
//                captureSession.beginConfiguration()
//                captureSession.sessionPreset = .low
//
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                } else {
//                    generateError(errorManager: errorManager,
//                                  additionalErrorDescription: "Could not add video device input to the session")
//                }
//
//                captureSession.commitConfiguration()
//
//                captureSession.startRunning()
//            } else {
//                generateError(errorManager: errorManager,
//                              additionalErrorDescription: "Error getting input from camera")
//            }
//        } else {
//            generateError(errorManager: errorManager,
//                          additionalErrorDescription: "Error getting capture device")
//        }
    }
}

struct CameraPreview: UIViewRepresentable {
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
