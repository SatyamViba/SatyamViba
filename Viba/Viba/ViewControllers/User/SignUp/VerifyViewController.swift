//
//  VerifyViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class VerifyViewController: UIViewController {
    weak var delegate: SignupProtocol?
    
    @IBOutlet weak var infoBtn: UILabel!
    @IBOutlet weak var boxView: VibaRoundCornerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        boxView.layer.borderColor = UIColor.darkGray.cgColor
        boxView.layer.borderWidth = 0.5

        infoBtn.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        infoBtn.text = String.fontAwesomeIcon(name: .infoCircle)
        infoBtn.textColor = .lightGray
        
    }

    @IBAction func validateAndSendData(_ sender: Any) {
        guard let dlgt = delegate else {
            return
        }

        dlgt.didFinish(screen: .verify)
    }

    @IBAction func resendEmailOtp(_ sender: Any) {
    }

    @IBAction func resendMobileOtp(_ sender: Any) {
    }
    
}
