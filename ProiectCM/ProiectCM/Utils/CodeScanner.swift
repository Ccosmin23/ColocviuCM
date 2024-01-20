//
//  CodeScanner.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 16.10.2021.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit


typealias ScanResult<Success, ScanError> = Swift.Result<String, Error>

enum ScanError: Error {
    case badInput
    case badOutput
}

enum ScanMode {
    case once
    case oncePerCode
    case continuous
}

struct CodeScannerView: UIViewControllerRepresentable {
    let codeTypes: [AVMetadataObject.ObjectType]
    let scanMode: ScanMode
    let scanInterval: Double
    let showViewfinder: Bool
    var simulatedData = ""
    var completion: (ScanResult<String, ScanError>) -> Void
    
    init(codeTypes: [AVMetadataObject.ObjectType], scanMode: ScanMode = .once, showViewfinder: Bool = false, scanInterval: Double = 2.0, simulatedData: String = "", completion: @escaping (ScanResult<String, ScanError>) -> Void) {
        
        self.codeTypes = codeTypes
        self.scanMode = scanMode
        self.showViewfinder = showViewfinder
        self.scanInterval = scanInterval
        self.simulatedData = simulatedData
        self.completion = completion
    }
    
    func makeCoordinator() -> ScannerCoordinator {
        return ScannerCoordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController(showViewfinder: showViewfinder)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        
    }
    
}


class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: CodeScannerView
    var codesFound: Set<String>
    var isFinishScanning = false
    var lastTime = Date(timeIntervalSince1970: 0)
    
    init(parent: CodeScannerView) {
        self.parent = parent
        self.codesFound = Set<String>()
    }
    
    func reset()
    {
        self.codesFound = Set<String>()
        self.isFinishScanning = false
        self.lastTime = Date(timeIntervalSince1970: 0)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            guard isFinishScanning == false else { return }
            
            switch self.parent.scanMode {
            case .once:
                found(code: stringValue)
                // make sure we only trigger scan once per use
                isFinishScanning = true
            case .oncePerCode:
                if !codesFound.contains(stringValue) {
                    codesFound.insert(stringValue)
                    found(code: stringValue)
                }
            case .continuous:
                if isPastScanInterval() {
                    found(code: stringValue)
                }
            }
        }
    }
    
    func isPastScanInterval() -> Bool {
        return Date().timeIntervalSince(lastTime) >= self.parent.scanInterval
    }
    
    func found(code: String) {
        lastTime = Date()
        parent.completion(.success(code))
    }
    
    func didFail(reason: ScanError) {
        parent.completion(.failure(reason))
    }
    
}



class ScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: ScannerCoordinator?
    let videoCaptureDevice = AVCaptureDevice.default(for: .video)
    
    let showViewfinder: Bool
    
    lazy var viewFinder: UIImageView? = {
        guard let image = UIImage(named: "viewfinder", in: nil, with: nil) else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(showViewfinder: Bool) {
        self.showViewfinder = showViewfinder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.showViewfinder = false
        super.init(coder: coder)
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOrientation),
                                               name: Notification.Name("UIDeviceOrientationDidChangeNotification"),
                                               object: nil)
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = videoCaptureDevice else {
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            delegate?.didFail(reason: .badInput)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = delegate?.parent.codeTypes
        } else {
            delegate?.didFail(reason: .badOutput)
            return
        }
    }
    
    override  func viewWillLayoutSubviews() {
        previewLayer?.frame = view.layer.bounds
    }
    
    @objc func updateOrientation() {
        guard let orientation = view.window?.windowScene?.interfaceOrientation else { return }
        guard let connection = captureSession.connections.last, connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
    }
    
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateOrientation()
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        }
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        addviewfinder()
        
        delegate?.reset()
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    func addviewfinder() {
        guard showViewfinder, let imageView = viewFinder else { return }
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    override  func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override  var prefersStatusBarHidden: Bool {
        return true
    }
    
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    /** Touch the screen for autofocus */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first?.view == view,
              let touchPoint = touches.first,
              let device = videoCaptureDevice
        else { return }
        
        let videoView = view
        let screenSize = videoView!.bounds.size
        let xPoint = touchPoint.location(in: videoView).y / screenSize.height
        let yPoint = 1.0 - touchPoint.location(in: videoView).x / screenSize.width
        let focusPoint = CGPoint(x: xPoint, y: yPoint)
        
        do {
            try device.lockForConfiguration()
        } catch {
            return
        }
        
        // Focus to the correct point, make continiuous focus and exposure so the point stays sharp when moving the device closer
        device.focusPointOfInterest = focusPoint
        device.focusMode = .continuousAutoFocus
        device.exposurePointOfInterest = focusPoint
        device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
        device.unlockForConfiguration()
    }
}
