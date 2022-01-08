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
    var userImage: UIImage?
    @IBOutlet var submitBtn: VibaButton!
    @IBOutlet var picture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showFaceCapture()
    }

    private func showFaceCapture() {
        delegate?.showFaceView(onCompletion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.userImage = UIImage(cgImage: image).withHorizontallyFlippedOrientation()
                    self.picture.image = self.userImage
                case .notFound:
                    self.showWarning(message: "Failed to detect face")
                case .failure(let err):
                    self.showWarning(message: err.localizedDescription)
                }
            }
        })
    }

    @IBAction func reCapture(_ sender: Any) {
        showFaceCapture()
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
