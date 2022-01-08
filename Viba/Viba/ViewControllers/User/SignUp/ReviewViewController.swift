//
//  ReviewViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/01/22.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var tick: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
