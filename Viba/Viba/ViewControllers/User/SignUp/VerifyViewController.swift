//
//  VerifyViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class VerifyViewController: UIViewController {
    weak var delegate: SignupProtocol?
    
    @IBOutlet weak var infoBtn: UILabel!
    @IBOutlet weak var boxView: VibaRoundCornerView!

    @IBOutlet weak var smsOtp: VibaTextField!
    @IBOutlet weak var emailOtp: VibaTextField!
    let charLimit = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        boxView.layer.borderColor = UIColor.darkGray.cgColor
        boxView.layer.borderWidth = 0.5

        infoBtn.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        infoBtn.text = String.fontAwesomeIcon(name: .infoCircle)
        infoBtn.textColor = .lightGray
        
    }

    @IBAction func validateAndSendData(_ sender: Any) {
        guard let dlgt = delegate else {
            return
        }

        dlgt.didFinish(screen: .verify)
        return

        guard let eOtp = emailOtp.text, eOtp.count == charLimit else {
            emailOtp.showError()
            return
        }

        guard let sOtp = smsOtp.text, sOtp.count == charLimit else {
            smsOtp.showError()
            return
        }

        guard let usrId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId.value) else {
            showWarning(title: "Warning!", message: "User ID is invalid")
            return
        }

        showLoadingIndicator()
        UserRequests.validateRegistrationOtps(email: eOtp, phone: sOtp, userId: usrId) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch result {
                case .success(let status):
                    print("\(status.msg)")
                    guard let dlgt = delegate else {
                        return
                    }

                    dlgt.didFinish(screen: .verify)
                case .failure(let error):
                    print(error.localizedDescription)
                    showWarning(title: "Warning!", message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func resendEmailOtp(_ sender: Any) {
        guard let usrId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId.value) else {
            showWarning(title: "Warning!", message: "User ID is invalid")
            return
        }

        showLoadingIndicator()
        UserRequests.resendEmailOtp(userId: usrId) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch result {
                case .success(let response):
                    print("### Resend Email OTP Status: \(response.msg)")
                    showWarning(title: "Successful", message: "You will receive an email")
                case .failure(let error):
                    print(error.localizedDescription)
                    showWarning(message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func resendMobileOtp(_ sender: Any) {
        guard let usrId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId.value) else {
            showWarning(message: "User ID is invalid")
            return
        }
        
        showLoadingIndicator()
        UserRequests.resendEmailOtp(userId: usrId) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch result {
                case .success(let response):
                    print("### Resend SMS OTP Status: \(response.msg)")
                    showSuccessAlert(message: "You will receive a message")
                case .failure(let error):
                    print(error.localizedDescription)
                    showWarning(message: error.localizedDescription)
                }
            }
        }
    }
    
}

extension VerifyViewController: UITextFieldDelegate {
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,
                              newText: string,
                              limit: charLimit)
    }
}
