//
//  ViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit
import SCLAlertView

class LoginViewController: UIViewController {
    var authType = AuthType.email

    @IBOutlet weak var userId: VibaTextField!
    @IBOutlet weak var companyCode: VibaTextField!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        companyCode.text = "VIBA-IDEEOTECHS-6PFJ"
        #endif
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPView" {
            guard let destVc = segue.destination as? OTPViewController, let text = userId.text else {
                return
            }

            destVc.authType = self.authType
            destVc.userEnteredId = "91" + text
        }
    }

    @IBAction func requestOTP(_ sender: Any) {
        performSegue(withIdentifier: "Dashboard", sender: nil)
        /*
        guard let text = userId.text, text.count > 0 else {
            userId.showError()
            return
        }

        if text.isValidEmail {
            authType = .email
        } else if text.isValidPhone {
            authType = .mobile
        } else {
            userId.showError()
            return
        }

        showLoadingIndicator()
        UserRequests.authenticate(type: authType, id: authType == .email ? text : "91" + text) { response in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch response {
                case .success(let status):
                    print(status)
                    self.performSegue(withIdentifier: "OTPView", sender: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    SCLAlertView().showWarning("Warning!", subTitle: "Failed to validate input")
                }
            }
        }
        */
    }

    @IBAction func signupUser(_ sender: Any) {
        // self.performSegue(withIdentifier: "SignupView", sender: nil)
        guard let code = companyCode.text, code.count > 0 else {
            companyCode.showError()
            return
        }

        showLoadingIndicator()
        UserRequests.validateCompany(code: code) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch result {
                case .success(let companyDetails):
                    print("company details: \(companyDetails)")
                    UserDefaults.standard.set(companyDetails.id, forKey: UserDefaultsKeys.companyId.value)

                    self.performSegue(withIdentifier: "SignupView", sender: nil)
                case .failure(let err):
                    print(err.localizedDescription)
                    SCLAlertView().showWarning("Warning!", subTitle: err.localizedDescription)
                }
            }
        }
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
