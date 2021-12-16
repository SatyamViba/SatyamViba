//
//  FaceCaptureViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit
import AVFoundation

class FaceCaptureViewController: UIViewController {
    var delegate: SignupProtocol?
    @IBOutlet var mlView: FaceTrackingView!
    @IBOutlet var submitBtn: VibaButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            showWarning(message: "You have to enable camera permission")
        }
        mlView.initializeFaceTracking()
        view.setNeedsLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mlView.updateFrames()
    }

    @IBAction func validateAndSendData(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            showWarning(message: "You have to enable camera permission")
            return
        }

        guard let dlgt = delegate else {
            return
        }

        dlgt.didFinish(screen: .faceCapture)
    }
}
