//
//  OTPViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 09/11/21.
//

import UIKit
import FontAwesome_swift
import OTPFieldView

class OTPViewController: UIViewController {

    @IBOutlet weak var otpField: OTPFieldView!
    @IBOutlet weak var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.otpField.fieldsCount = 5
        self.otpField.secureEntry = true
        self.otpField.otpInputType = .numeric
        self.otpField.fieldBorderWidth = 2
        self.otpField.defaultBorderColor = .black
        self.otpField.filledBorderColor = Colors.gradientRed.value
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

}

extension OTPViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otp: String) {
        print(otp)
    }

    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        print("Has entered all OTP? \(hasEnteredAll)")
        return false
    }
}
