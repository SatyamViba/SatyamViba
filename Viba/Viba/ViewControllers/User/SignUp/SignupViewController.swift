//
//  SignupViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit
import DatePicker

protocol SignupPageViewProtocol: AnyObject {
    func updatePageIndicator(screen: SignupScreens)
    func selectDate(onCompletion: @escaping ((Date) -> Void))
}

class SignupViewController: UIViewController {
    @IBOutlet weak var firstIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var secondIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var thirdIndicatorWidth: NSLayoutConstraint!

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstIndicatorWidth.constant = 50
        firstView.backgroundColor = Colors.vibaRed.value

        let gestrue = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        view.addGestureRecognizer(gestrue)
    }

    @objc private func stopEditing() {
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageContrroller", let dest = segue.destination as? SignupPageViewController {
            dest.signupDelegate = self
        }
    }
}

extension SignupViewController: SignupPageViewProtocol {
    func selectDate(onCompletion handler: @escaping ((Date) -> Void)) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 1950)!
        let maxDate = Date().subtract(years: 18)
        let today = Date()
        // Create picker object
        let datePicker = DatePicker()
        // Setup
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                handler(selectedDate)
            }
        }
        // Display
        datePicker.show(in: self, on: nil)
    }

    func updatePageIndicator(screen: SignupScreens) {
        switch screen {
        case .employeeDetails:
            firstIndicatorWidth.constant = 30
            firstView.backgroundColor = Colors.vibaGreen.value
            secondIndicatorWidth.constant = 50
            secondView.backgroundColor = Colors.vibaRed.value
        case .verify:
            secondIndicatorWidth.constant = 30
            secondView.backgroundColor = Colors.vibaGreen.value
            thirdIndicatorWidth.constant = 50
            thirdView.backgroundColor = Colors.vibaRed.value
        case .faceCapture:
            print("Time to show dashbaord")
            // performSegue(withIdentifier: "Dashboard", sender: nil)
        }
    }
}
