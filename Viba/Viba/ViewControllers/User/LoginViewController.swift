//
//  ViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userId: VibaTextField!
    @IBOutlet weak var companyCode: VibaTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func requestOTP(_ sender: Any) {
        guard let text = userId.text, text.count > 0 else {
            userId.showError()
            return
        }
    }

    @IBAction func signupUser(_ sender: Any) {
        guard let text = companyCode.text, text.count > 0 else {
            companyCode.showError()
            return
        }
    }

}
