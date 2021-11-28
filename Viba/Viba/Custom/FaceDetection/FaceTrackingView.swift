//
//  FaceTrackingView.swift
//  FaceTracker
//
//  Created by Satyam Sutapalli on 27/11/21.
//  Copyright © 2021 Anurag Ajwani. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import VideoToolbox

class FaceTrackingView: UIView {
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var faceCapturingView: UIView!
    @IBOutlet var contentView: UIView!

    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var drawings: [CAShapeLayer] = []
    private var picCaptured = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = Colors.vibaRed.value
        
        Bundle.main.loadNibNamed("FaceTrackingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addCameraInput()
        showCameraFeed()
        getCameraFrames()
        captureSession.startRunning()
    }

    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
                fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
            }

        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(cameraInput)
        } catch {
            print("Failed to initialize camera input: \(error.localizedDescription)")
        }
    }

    private func showCameraFeed() {
        previewLayer.videoGravity = .resizeAspectFill
        faceCapturingView.layer.addSublayer(previewLayer)
        previewLayer.frame = faceCapturingView.bounds
    }

    private func getCameraFrames() {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        captureSession.addOutput(videoDataOutput)
        guard let connection = videoDataOutput.connection(with: AVMediaType.video),
              connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }

    @objc private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { [self] (request, error) in
            if let err = error {
                print("Failed to detect face landmark request: \(err.localizedDescription)")
                return
            }

            // Extract the observations and verify if the face count is 1 and get it.
            if let results = request.results as? [VNFaceObservation], results.count == 1, let result = results.first {
                if #available(iOS 15.0, *) {
                    print(result.pitch ?? "no_pitch", result.yaw ?? "no_yaw", result.roll ?? "no_roll")
                } else {
                    // Fallback on earlier versions
                    print(result.yaw ?? "no_yaw", result.roll ?? "no_roll")
                }

                picCaptured = true
                captureSession.stopRunning()
                DispatchQueue.main.async {
                    contentView.backgroundColor = .green
                    capturedImageView.image = UIImage(pixelBuffer: image)!.withHorizontallyFlippedOrientation()
                    bringSubviewToFront(capturedImageView)
                }
            }
        }

        if !picCaptured {
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
            do {
                try imageRequestHandler.perform([faceDetectionRequest])
            } catch {
                print(error, error.localizedDescription)
            }
        }
    }

    func updateFrames() {
        previewLayer.frame = faceCapturingView.bounds
    }
}

extension FaceTrackingView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        if !picCaptured {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // your code here
                self.detectFace(in: buffer)
            }
        }
    }
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}
