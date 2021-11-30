//
//  PicCaptureViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import UIKit

class PicCaptureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showDashboarrd(_ sender: Any) {
        performSegue(withIdentifier: "Dashboard", sender: nil)
    }
}
