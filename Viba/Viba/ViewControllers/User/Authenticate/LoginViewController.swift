//
//  ViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {
    var authType = AuthType.email

    @IBOutlet var userId: VibaTextField!
    @IBOutlet var companyCode: VibaTextField!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        userId.text = "9886555469" // "1111111110"
        companyCode.text = "VIBA-IDEEOTECHS-6PFJ"
        #endif
        UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.selectedMenu.value)
        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)

        if view.frame.size.height <= 667 {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.clear()  // Clear all the stored data

        if !Location.manager.isLocationServicesEnabled || AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            performSegue(withIdentifier: "PermissionsView", sender: nil)
        }
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
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

    @objc
    func keyboardWillHide(notification: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }

    @objc
    private func stopEditing() {
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
//        #if DEBUG
//        if UserDefaults.standard.string(forKey: UserDefaultsKeys.token.value) != nil {
//            performSegue(withIdentifier: "Dashboard", sender: nil)
//            return
//        }
//        #endif

        guard let text = userId.text, !text.isEmpty else {
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
        UserServices.authenticate(type: authType, id: authType == .email ? text : "91" + text) { response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                switch response {
                case .success(let status):
                    print(status)
                    performSegue(withIdentifier: "OTPView", sender: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    showWarning(message: "Failed to validate input")
                }
            }
        }
    }

    @IBAction func signupUser(_ sender: Any) {
//        self.performSegue(withIdentifier: "SignupView", sender: nil)
//        return
        
        guard let code = companyCode.text, !code.isEmptyStr else {
            companyCode.showError()
            return
        }

        showLoadingIndicator()
        UserServices.validateCompany(code: code) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator {
                    switch result {
                    case .success(let companyDetails):
                        UserDefaults.standard.set(companyDetails.id, forKey: UserDefaultsKeys.companyId.value)
                        self.performSegue(withIdentifier: "SignupView", sender: nil)
                    case .failure(let err):
                        print(err.localizedDescription)
                        showWarning(message: err.localizedDescription)
                    }
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
