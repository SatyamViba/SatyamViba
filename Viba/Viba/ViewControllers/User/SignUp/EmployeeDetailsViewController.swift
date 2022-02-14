//
//  EmployeeDetailsViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {
    var delegate: SignupProtocol?
    
    @IBOutlet var firstName: VibaTextField!
    @IBOutlet var lastName: VibaTextField!
    @IBOutlet var dob: VibaTextField!
    @IBOutlet var email: VibaTextField!
    @IBOutlet var phone: VibaTextField!
    @IBOutlet var calendar: UIButton!
    @IBOutlet var genderError: UILabel!

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

    @IBAction func validateAndSendData(_ sender: Any) {
//        guard let dlgt = self.delegate else {
//            return
//        }
//
//        dlgt.didFinish(screen: .employeeDetails)
//        return

        guard let fName = firstName.text, !fName.isEmptyStr else {
            firstName.showError()
            return
        }

        guard let lName = lastName.text, !lName.isEmptyStr else {
            lastName.showError()
            return
        }

        guard let birthDay = dob.text, !birthDay.isEmpty else {
            dob.showError()
            return
        }

        guard let eml = email.text, eml.isValidEmail else {
            email.showError()
            return
        }

        guard let phn = phone.text, phn.isValidPhone else {
            phone.showError()
            return
        }

        if gender.isEmpty {
            genderError.isHidden = false
            return
        }

        guard let companyID = UserDefaults.standard.string(forKey: UserDefaultsKeys.companyId.value) else {
            return
        }

        showLoadingIndicator()
        UserServices.registerUser(params: RegisterUser(dob: formatDate(), gender: gender, email: eml, accountID: companyID, firstName: fName, lastName: lName, phone: "91" + phn)) { result in
            DispatchQueue.main.async { [self] in
                self.hideLoadingIndicator()
                switch result {
                case .success(let user):
                    print("### Status of registering: \(user)")
                    DataManager.shared.userId = user.id
                    guard let dlgt = self.delegate else {
                        return
                    }

                    dlgt.didFinish(screen: .employeeDetails)
                case .failure(let error):
                    print("### Error in Registering User: \(error.localizedDescription)")
                    showWarning(message: error.localizedDescription)
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
        view.endEditing(true)
        gender = "m"
        genderError.isHidden = true
    }

    @IBAction func handleTapOnFemale(_ sender: Any) {
        view.endEditing(true)
        gender = "f"
        genderError.isHidden = true
    }

    @IBAction func selectDateofBirth(_ sender: Any) {
        view.endEditing(true)
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
