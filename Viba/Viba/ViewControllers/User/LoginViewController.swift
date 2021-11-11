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
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)

        if view.frame.size.height <= 667 {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        //         self.view.frame.origin.y = -150 // Move view 150 points upward
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }

        // if active text field is not nil
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height

            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                view.frame.origin.y = 0 - (bottomOfTextField - topOfKeyboard) - 50
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }

    @objc private func stopEditing() {
        view.endEditing(true)
    }

    @IBAction func requestOTP(_ sender: Any) {
//        guard let text = userId.text, text.count > 0 else {
//            userId.showError()
//            return
//        }

        performSegue(withIdentifier: "OTPView", sender: nil)
    }

    @IBAction func signupUser(_ sender: Any) {
//        guard let text = companyCode.text, text.count > 0 else {
//            companyCode.showError()
//            return
//        }
        performSegue(withIdentifier: "SignupView", sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        stopEditing()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        activeTextField = textField
    }

    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
