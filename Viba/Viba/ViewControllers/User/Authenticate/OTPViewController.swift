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

    @IBOutlet weak var errMessage: UILabel!
    var hasEnteredOtp = false
    @IBOutlet weak var otpField: OTPFieldView!
    @IBOutlet weak var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.otpField.fieldsCount = 5
        self.otpField.secureEntry = true
        self.otpField.otpInputType = .numeric
        self.otpField.fieldBorderWidth = 2
        self.otpField.defaultBorderColor = .black
        self.otpField.filledBorderColor = Colors.vibaRed.value
        self.otpField.cursorColor = UIColor.red
        self.otpField.displayType = .roundedCorner
        self.otpField.fieldSize = 50
        self.otpField.separatorSpace = 14
        self.otpField.shouldAllowIntermediateEditing = false
        self.otpField.delegate = self
        self.otpField.initializeUI()

        backBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight

        let img = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        backBtn.setImage(img, for: .normal)
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
        UserRequests.validateOtp(type: authType, id: id, otp: enteredOtp) { response in
            DispatchQueue.main.async { [self] in
                perform(#selector(hideLoadingIndicator), on: .main, with: nil, waitUntilDone: true)
                switch response {
                case .success(let authResponse):
                    print(authResponse)
                    UserDefaults.standard.set(authResponse.token, forKey: UserDefaultsKeys.token.value)
                    UserDefaults.standard.set(authResponse.data.image, forKey: UserDefaultsKeys.userImage.value)
                    DispatchQueue.main.async { [self] in
                        performSegue(withIdentifier: "PicView", sender: nil)
                    }
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
        print("Has entered all OTP? \(hasEnteredAll)")
        hasEnteredOtp = hasEnteredAll
        return true
    }
}
