//
//  ViewController.swift
//  testCameraIOS
//
//  Created by Fernando Oliveira on 08/06/17.
//  Copyright © 2017 Fernando Oliveira. All rights reserved.
//

import UIKit

import AVFoundation
class ViewController: UIViewController {
    let captureSession = AVCaptureSession()
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    var devices: [AVCaptureDevice]?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBAction func toggle(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            captureSession.sessionPreset = AVCaptureSession.Preset.high
            self.beginSession(devices![0])
            lbl.text = "??? 🤔 ???"
        } else {
            sender.isSelected = false
            self.stopSession(devices![0])
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
        devices = AVCaptureDevice.devices()
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: devices![0]))
        } catch {
            print("error: \(String(describing: err?.localizedDescription) )")
        }
    }
    
    func beginSession(_ captureDevice: AVCaptureDevice) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = self.view.bounds
        captureSession.startRunning()
        self.view.layer.addSublayer(previewLayer!)
    }
    
    func stopSession(_ captureDevice: AVCaptureDevice) {
        previewLayer?.removeFromSuperlayer()
        captureSession.stopRunning()
    }
}

