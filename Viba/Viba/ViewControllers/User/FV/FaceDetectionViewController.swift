//
//  FaceDetectionViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import AVFoundation
import UIKit
import Vision

class FaceDetectionViewController: UIViewController {
    var sequenceHandler = VNSequenceRequestHandler()
    @IBOutlet var faceView: FaceView!
    var faceHandler: ((FaceCropResult) -> Void)?
    var isProcessing = false
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!

    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCaptureSession()
        session.startRunning()
    }

    @IBAction func closeFaceCapture(_ sender: Any) {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }
}

// MARK: - Video Processing methods

extension FaceDetectionViewController {
    func configureCaptureSession() {
        // Define the capture device we want to use
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("No front video camera available")
        }

        // Connect the camera to the capture session input
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            session.addInput(cameraInput)
        } catch {
            fatalError(error.localizedDescription)
        }

        // Create the video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        // Add the video output to the capture session
        session.addOutput(videoOutput)

        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait

        // Configure the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = /* CGRect(x: 10, y: 10, width: 300, height: 300) */ view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods
extension FaceDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.detectFace(in: buffer)
        }
    }

    @objc
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { request, error in
            if let err = error {
                print("Failed to detect face landmark request: \(err.localizedDescription)")
                return
            }

            // Extract the observations and verify if the face count is 1 and get it.
            if let results = request.results as? [VNFaceObservation], results.count == 1,
                let result = results.first {
//                self.updateFaceView(for: result)
//                if #available(iOS 15.0, *) {
//                    print(results.count, result.pitch ?? "no_pitch", result.yaw ?? "no_yaw", result.roll ?? "no_roll")
//                } else {
//                    // Fallback on earlier versions
//                    print(results.count, result.yaw ?? "no_yaw", result.roll ?? "no_roll")
//                }
                if !self.isProcessing, let landmarks = result.landmarks, landmarks.confidence > 0.8, let yaw = result.yaw, yaw.doubleValue < 0.2 && yaw.doubleValue > -0.2, let roll = result.roll, roll.doubleValue > 1.0 && roll.doubleValue < 2.0 {
                    self.session.stopRunning()
                    self.isProcessing = true
                    if let fHandler = self.faceHandler, let navController = self.navigationController {
                        CGImage.create(pixelBuffer: image)?.faceCrop(margin: 10, completion: fHandler)
                        print(navController.viewControllers)
                        navController.popViewController(animated: true)
                    }
                }
            }
        }

        do {
            try sequenceHandler.perform([faceDetectionRequest], on: image, orientation: .leftMirrored)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension FaceDetectionViewController {
    func convert(rect: CGRect) -> CGRect {
        let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
        let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
        print(rect.origin, rect.size, origin, size)
        return CGRect(origin: origin, size: size.cgSize)
    }

    func updateFaceView(for result: VNFaceObservation) {
        defer {
            DispatchQueue.main.async {
                self.faceView.setNeedsDisplay()
            }
        }

        let box = convert(rect: result.boundingBox)
        faceView.boundingBox = box
    }

    func detectedFace(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNFaceObservation], results.count == 1, let result = results.first
        else {
            faceView.clear()
            return
        }

        updateFaceView(for: result)
    }
}
