//
//  CameraViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit
import AVFoundation
import SnapKit
import SDWebImage

class CameraViewController: UIViewController {
    
    private var output = AVCapturePhotoOutput()
    private var captureSession: AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let cameraView = UIView()
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = nil
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Take Photo"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(cameraView)
        view.addSubview(shutterButton)
        setupNavBar()
        checkCameraPermission()
//        setUpCamera()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
//            make.top.equalTo(view.safeAreaInsets.top)
        }
        //        layer.frame = view.layer.bounds
        previewLayer.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        
        let buttonSize: CGFloat = view.width / 5
        shutterButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.top.equalTo(view.safeAreaInsets.top + view.width + 100)
            make.centerX.equalTo(view.snp.centerX)
        }
        shutterButton.layer.cornerRadius = buttonSize / 2
    }
    
    @objc func didTapTakePhoto() {
        print("take photo ")
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @objc func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setUpCamera() {
        let captureSession = AVCaptureSession()
        
        // add device
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch {
                print(error)
            }
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }
            
            // layers
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            cameraView.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] grant in
                guard grant else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { // photo.fileDataRepresentation is an optional thus the reason we are unwrapping
            return
        }
        
        captureSession?.stopRunning()
        
        guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 640, height: 640), scaleMode: .aspectFill) else {
            return
        }
        
        let vc = PostEditViewController(image: resizedImage)
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController?.pushViewController(vc, animated: false)
        
    }
}
