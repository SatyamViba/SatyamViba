//
//  OTPViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 09/11/21.
//

import UIKit
import FontAwesome_swift
import OTPFieldView

enum AuthType {
    case email
    case mobile
}

class OTPViewController: UIViewController {
    var authType = AuthType.email
    var userEnteredId: String?
    var enteredOtp = ""
    var hasEnteredOtp = false
    var authResponse: LoginOTPResponse?

    @IBOutlet var errMessage: UILabel!
    @IBOutlet var otpField: OTPFieldView!
    @IBOutlet var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.otpField.fieldsCount = 5
        self.otpField.secureEntry = false
        self.otpField.otpInputType = .numeric
        self.otpField.fieldBorderWidth = 2
        self.otpField.defaultBorderColor = .black
        self.otpField.filledBorderColor = Colors.vibaRed.value
        self.otpField.cursorColor = UIColor.red
        self.otpField.displayType = .roundedCorner
        self.otpField.fieldSize = 50
        self.otpField.separatorSpace = 8
        self.otpField.shouldAllowIntermediateEditing = false
        self.otpField.delegate = self
        self.otpField.initializeUI()

        backBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight

        let img = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        backBtn.setImage(img, for: .normal)

        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)
    }

    @objc
    private func stopEditing() {
        view.endEditing(true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func validedOtp(_ sender: Any) {
        guard hasEnteredOtp == true, let id = userEnteredId else {
            showWarning(message: "Please enter valid OTP")
            return
        }

        showLoadingIndicator()
        UserServices.validateOtp(type: authType, id: id, otp: enteredOtp) { response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                switch response {
                case .success(let authResponse):
                    self.authResponse = authResponse
                    perform(#selector(showNextView), with: nil, afterDelay: 1.0)
                case .failure(let error):
                    print(error.localizedDescription)
                    showWarning(message: "Failed to validate input")
                }
            }
        }
    }

    @objc
    private func showNextView() {
        guard let response = authResponse else {
            return
        }

        UserDefaults.standard.set(response.token, forKey: UserDefaultsKeys.token.value)
        DataManager.shared.usrImage = response.data.image
        DataManager.shared.fullName = response.data.fullName
        
        DispatchQueue.main.async { [self] in
            performSegue(withIdentifier: "PicView", sender: nil)
        }
    }

    private func clear() {
        hasEnteredOtp = false
        enteredOtp = ""
        otpField.clear()
    }

    @IBAction func resendOtp(_ sender: Any) {
        guard let uid = userEnteredId else {
            return
        }
        clear()
        showLoadingIndicator()
        UserServices.authenticate(type: authType, id: authType == .email ? uid : uid) { response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                switch response {
                case .success(let status):
                    print(status)
//                    performSegue(withIdentifier: "OTPView", sender: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    showWarning(message: "Failed to validate input")
                }
            }
        }
    }
}

extension OTPViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otp: String) {
        enteredOtp = otp
    }

    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        hasEnteredOtp = hasEnteredAll
        return true
    }
}

extension OTPFieldView {
    func clear() {
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            let oldOtpField = viewWithTag(index + 1) as? UITextField
            oldOtpField?.text = ""
            oldOtpField?.backgroundColor = defaultBackgroundColor
            oldOtpField?.layer.borderColor = defaultBorderColor.cgColor
            oldOtpField?.resignFirstResponder()
        }
    }
}
