//
//  SignupViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var firstIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var secondIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var thirdIndicatorWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstIndicatorWidth.constant = 50
    }
}
