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

    private var sequenceHandler = VNSequenceRequestHandler()
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
    }

    func initializeFaceTracking() {
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
                fatalError("No front camera device found, please make sure to run the app in an iOS device and not a simulator")
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

//        let faceDetectionRequest = VNDetectFaceLandmarksRequest { [self] (request, error) in
//            if let err = error {
//                print("Failed to detect face landmark request: \(err.localizedDescription)")
//                return
//            }
//
//            // Extract the observations and verify if the face count is 1 and get it.
//            if let results = request.results as? [VNFaceObservation], results.count == 1, let result = results.first {
//                if #available(iOS 15.0, *) {
//                    print(result.pitch ?? "no_pitch", result.yaw ?? "no_yaw", result.roll ?? "no_roll")
//                } else {
//                    // Fallback on earlier versions
//                    print(result.yaw ?? "no_yaw", result.roll ?? "no_roll")
//                }
//
//                picCaptured = true
//                captureSession.stopRunning()
//                DispatchQueue.main.async {
//                    contentView.backgroundColor = .green
//                    capturedImageView.image = UIImage(pixelBuffer: image)!.withHorizontallyFlippedOrientation()
//                    bringSubviewToFront(capturedImageView)
//                }
//            }
//        }

        let faceDetectionRequest = VNDetectFaceRectanglesRequest {[self] (request, error) in
            if let err = error {
                print("Failed to detect face rectangles: ", err.localizedDescription)
                return
            }

            if let results = request.results as? [VNFaceObservation], results.count == 1, let result = results.first {
                print(result.boundingBox)
                convert(rect: result.boundingBox)
//                picCaptured = true
//                captureSession.stopRunning()
//                DispatchQueue.main.async {
//                    contentView.backgroundColor = .green
//                    capturedImageView.image = UIImage(pixelBuffer: image)!.withHorizontallyFlippedOrientation()
//                    bringSubviewToFront(capturedImageView)
//                }
            }
        }

        if !picCaptured {
            do {
              try sequenceHandler.perform([faceDetectionRequest], on: image, orientation: .leftMirrored)
            } catch {
              print(error.localizedDescription)
            }
        }
    }

    private func convert(rect: CGRect) -> CGRect {
      let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
      let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
      return CGRect(origin: origin, size: size.cgSize)
    }

//    func updateFaceView(for result: VNFaceObservation) {
//      defer {
//        DispatchQueue.main.async {
//          self.faceView.setNeedsDisplay()
//        }
//      }
//
//      let box = result.boundingBox
//      faceView.boundingBox = convert(rect: box)
//
//      guard let landmarks = result.landmarks else {
//        return
//      }
//
//      if let leftEye = landmark(
//        points: landmarks.leftEye?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.leftEye = leftEye
//      }
//
//      if let rightEye = landmark(
//        points: landmarks.rightEye?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.rightEye = rightEye
//      }
//
//      if let leftEyebrow = landmark(
//        points: landmarks.leftEyebrow?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.leftEyebrow = leftEyebrow
//      }
//
//      if let rightEyebrow = landmark(
//        points: landmarks.rightEyebrow?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.rightEyebrow = rightEyebrow
//      }
//
//      if let nose = landmark(
//        points: landmarks.nose?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.nose = nose
//      }
//
//      if let outerLips = landmark(
//        points: landmarks.outerLips?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.outerLips = outerLips
//      }
//
//      if let innerLips = landmark(
//        points: landmarks.innerLips?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.innerLips = innerLips
//      }
//
//      if let faceContour = landmark(
//        points: landmarks.faceContour?.normalizedPoints,
//        to: result.boundingBox) {
//        faceView.faceContour = faceContour
//      }
//    }


//    private func detectRectangle(in image: CVPixelBuffer) {
//        let request = VNDetectRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
//            DispatchQueue.main.async {
//                guard let results = request.results as? [VNRectangleObservation] else { return }
//                //removeBoundingBoxLayer()
//                //retrieve the first observed rectangle
//                guard let rect = results.first else{return}
//                //function used to draw the bounding box of the detected rectangle
//                //self.drawBoundingBox(rect: rect)
//            }
//        })
//        //Set the value for the detected rectangle
//        request.minimumAspectRatio = VNAspectRatio(0.3)
//        request.maximumAspectRatio = VNAspectRatio(0.9)
//        request.minimumSize = Float(0.3)
//        request.maximumObservations = 1
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
//        try? imageRequestHandler.perform([request])
//    }

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
