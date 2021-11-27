//
//  SendPreInvitationViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 27/11/21.
//

import UIKit
import DatePicker

class SendPreInvitationViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var invitationImage: UIImageView!

    @IBOutlet weak var fullName: VibaTextField!
    @IBOutlet weak var email: VibaTextField!
    @IBOutlet weak var phoneNumber: VibaTextField!
    @IBOutlet weak var invitationType: UISegmentedControl!
    @IBOutlet weak var appointmentDate: VibaTextField!
    @IBOutlet weak var startTime: VibaTextField!
    @IBOutlet weak var endTime: VibaTextField!
    @IBOutlet weak var calendar: UIButton!

    var activeTextField: UITextField?
    var selectedDate = Date()
    var timePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        invitationImage.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))

        let calImg = UIImage.fontAwesomeIcon(name: .calendarAlt, style: .regular, textColor: .black, size: CGSize(width: 40, height: 40))
        calendar.setImage(calImg, for: .normal)

        let img = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        backBtn.setImage(img, for: .normal)

        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)

        if view.frame.size.height <= 667 {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

//        let customView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 160))
//        customView.backgroundColor = .brown
//        timePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 160))
//        customView .addSubview(timePicker)
//        startTime.inputView = customView
//        let doneButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 44))
//        doneButton.setTitle("Done", for: .normal)
//        doneButton.addTarget(self, action: #selector(datePickerSelected), for: .touchUpInside)
//        doneButton.backgroundColor = .blue
//        startTime.inputAccessoryView = doneButton
    }

//    @objc func datePickerSelected() {
//           startTime.text =  timePicker.date.description
//       }

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
    
    @IBAction func goBack(_ sender: Any) {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }

    @IBAction func submitInvitatioon(_ sender: Any) {
        view.endEditing(true)
        if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }

    @IBAction func selectAppointmentDate(_ sender: Any) {
        view.endEditing(true)
        let maxDate = Date().add(days: 60)
        let today = Date()
        // Create picker object
        let datePicker = DatePicker()
        // Setup
        datePicker.setup(beginWith: today, min: today, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                self.selectedDate = selectedDate
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.appointmentDate.text = formatter.string(from: selectedDate)
            }
        }
        // Display
        datePicker.show(in: self, on: nil)
    }
}

extension SendPreInvitationViewController: UITextFieldDelegate {
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
