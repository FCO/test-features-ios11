//
//  ViewController.swift
//  testCameraIOS
//
//  Created by Fernando Oliveira on 08/06/17.
//  Copyright © 2017 Fernando Oliveira. All rights reserved.
//

import UIKit

import AVFoundation
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let captureSession = AVCaptureSession()
    var count = 0
    let model = Inceptionv3()
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    private let device = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices[0]
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let sessionQueue    = DispatchQueue(label: "session queue")
    
    @IBAction func toggle(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            captureSession.sessionPreset = AVCaptureSession.Preset.high
            self.beginSession(device)
            lbl.text = "??? 🤔 ???"
        } else {
            sender.isSelected = false
            self.stopSession(device)
            lbl.text = ""
        }
        self.toFront()
    }
    func toFront() {
        for view in [btn as UIView, lbl as UIView] {
            self.view.bringSubview(toFront: view)
        }
    }
    override func viewDidLoad() {
        let err : NSError? = nil
        btn.setTitle("start", for: .normal)
        btn.setTitle("stop", for: .selected)
        
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: device))
        } catch {
            print("error: \(String(describing: err?.localizedDescription) )")
        }
        
        let testOutput = AVCaptureVideoDataOutput()
        testOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        captureSession.addOutput(testOutput)
    }
    
    func beginSession(_ captureDevice: AVCaptureDevice) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = self.view.bounds
        sessionQueue.async { [unowned self] in
            self.captureSession.startRunning()
        }
        self.view.layer.addSublayer(previewLayer!)
    }
    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async { [unowned self] in
            do {
                let response = try self.model.prediction(image: sampleBuffer as! CVPixelBuffer)
                self.lbl.text = response.classLabel
            } catch {
                self.lbl.text = "??? 🤔 ???"
            }
        }
    }
    
    func stopSession(_ captureDevice: AVCaptureDevice) {
        previewLayer?.removeFromSuperlayer()
        captureSession.stopRunning()
    }
}

