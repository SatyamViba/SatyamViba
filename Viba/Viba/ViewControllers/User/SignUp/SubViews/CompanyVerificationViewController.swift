//
//  CompanyVerificationViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 23/02/22.
//

import UIKit

class CompanyVerificationViewController: UIViewController {
    var delegate: SignupProtocol?
    @IBOutlet var companyCode: VibaTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
#if DEBUG
        companyCode.text = "VIBA-IDEEOTECHS-6PFJ"
#endif

        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)
    }

    @objc
    private func stopEditing() {
        view.endEditing(true)
    }

    @IBAction func signupUser(_ sender: Any) {
        delegate?.didFinish(screen: .companyDetails)
        return

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
                        delegate?.didFinish(screen: .companyDetails)
                    case .failure(let err):
                        print(err.localizedDescription)
                        showInfo(message: err.localizedDescription)
                    }
                }
            }
        }
    }
}

extension CompanyVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        stopEditing()
        return true
    }
}
