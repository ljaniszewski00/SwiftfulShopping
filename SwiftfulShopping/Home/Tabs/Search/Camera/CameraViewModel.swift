//
//  CameraModel.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 17/08/2022.
//

import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var pixelBuffer: CVPixelBuffer?
    
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
    
    private func checkPermission(completion: @escaping ((Bool) -> Void)) {
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
                    captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                    captureSession.addOutput(captureOutput)
                }
            }
            captureSession.commitConfiguration()
            startCapturing()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            DispatchQueue.main.async {
                self.pixelBuffer = pixelBuffer
            }
        }
    }
    
    func startCapturing() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopCapturing() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}
