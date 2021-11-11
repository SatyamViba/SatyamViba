//
//  SignupViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

protocol SignupPageViewProtocol: AnyObject {
    func updatePageIndicator(screen: SignupScreens)
}

class SignupViewController: UIViewController {
    @IBOutlet weak var firstIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var secondIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var thirdIndicatorWidth: NSLayoutConstraint!

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstIndicatorWidth.constant = 50
        firstView.backgroundColor = Colors.vibaRed.value

        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)
    }

    @objc private func stopEditing() {
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageContrroller", let dest = segue.destination as? SignupPageViewController {
            dest.signupDelegate = self
        }
    }
}

extension SignupViewController: SignupPageViewProtocol {
    func updatePageIndicator(screen: SignupScreens) {
        switch screen {
        case .employeeDetails:
            firstIndicatorWidth.constant = 30
            firstView.backgroundColor = Colors.vibaGreen.value
            secondIndicatorWidth.constant = 50
            secondView.backgroundColor = Colors.vibaRed.value
        case .verify:
            secondIndicatorWidth.constant = 30
            secondView.backgroundColor = Colors.vibaGreen.value
            thirdIndicatorWidth.constant = 50
            thirdView.backgroundColor = Colors.vibaRed.value
        case .faceCapture:
            print("yet to handle")
        }
    }
}
