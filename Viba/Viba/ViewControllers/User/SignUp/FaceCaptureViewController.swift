//
//  FaceCaptureViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class FaceCaptureViewController: UIViewController {
    weak var delegate: SignupProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func validateAndSendData(_ sender: Any) {
        guard let dlgt = delegate else {
            return
        }

        dlgt.didFinish(screen: .faceCapture)
    }
}
