//
//  EmployeeDetailsViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit
import SCLAlertView

class EmployeeDetailsViewController: UIViewController {
    weak var delegate: SignupProtocol?
    
    @IBOutlet weak var firstName: VibaTextField!
    @IBOutlet weak var lastName: VibaTextField!
    @IBOutlet weak var dob: VibaTextField!
    @IBOutlet weak var email: VibaTextField!
    @IBOutlet weak var phone: VibaTextField!
    @IBOutlet weak var calendar: UIButton!
    @IBOutlet weak var genderError: UILabel!

    var selectedDate = Date()
    var activeTextField: UITextField?
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let img = UIImage.fontAwesomeIcon(name: .calendarAlt, style: .regular, textColor: .black, size: CGSize(width: 40, height: 40))
        calendar.setImage(img, for: .normal)
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

    @IBAction func validateAndSendData(_ sender: Any) {
//        guard let dlgt = self.delegate else {
//            return
//        }
//
//        dlgt.didFinish(screen: .employeeDetails)
        guard let fName = firstName.text, fName.count > 0 else {
            firstName.showError()
            return
        }

        guard let lName = lastName.text, lName.count > 0 else {
            lastName.showError()
            return
        }

        guard let birthDay = dob.text, birthDay.count > 0 else {
            dob.showError()
            return
        }

        guard let eml = email.text, eml.count > 0 else {
            email.showError()
            return
        }

        guard let phn = phone.text, phn.isValidPhone else {
            phone.showError()
            return
        }

        if gender.count == 0 {
            genderError.isHidden = false
            return
        }

        guard let companyID = UserDefaults.standard.string(forKey: UserDefaultsKeys.companyId.value) else {
            return
        }

        showLoadingIndicator()
        UserRequests.registerUser(params: RegisterUserStep1(dob: formatDate(), gender: gender, email: eml, accountID: companyID, firstName: fName, lastName: lName, phone: "91" + phn)) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch result {
                case .success(let user):
                    print("Status of registering: \(user)")
                    UserDefaults.standard.set(user.id, forKey: UserDefaultsKeys.userId.value)
                    guard let dlgt = self.delegate else {
                        return
                    }

                    dlgt.didFinish(screen: .employeeDetails)
                case .failure(let error):
                    print("Error in Registering User: \(error.localizedDescription)")
                    SCLAlertView().showWarning("Warning!", subTitle: error.localizedDescription)
                }
            }
        }
    }

    private func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self.selectedDate)
    }

    @IBAction func handleTapOnMale(_ sender: Any) {
        gender = "m"
        genderError.isHidden = true
    }

    @IBAction func handleTapOnFemale(_ sender: Any) {
        gender = "f"
        genderError.isHidden = true
    }

    @IBAction func selectDateofBirth(_ sender: Any) {
        guard let dlgt = delegate else {
            return
        }

        dlgt.selectDate { selDate in
            self.selectedDate = selDate
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            self.dob.text = formatter.string(from: selDate)
        }
    }
}

extension EmployeeDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
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
