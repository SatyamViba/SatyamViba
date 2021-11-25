//
//  TimesheetViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit
import FontAwesome_swift
import DatePicker

class TimesheetViewController: UIViewController {
    private let minDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 2000)!
    @IBOutlet weak var eventList: UITableView!
    @IBOutlet weak var timesheetImage: UIImageView!

    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calendar: UIButton!
    @IBOutlet weak var right: UIButton!

    @IBOutlet weak var wfoImg: VibaCircularImage!
    @IBOutlet weak var wfoTime: UILabel!

    @IBOutlet weak var wfhImg: VibaCircularImage!
    @IBOutlet weak var wfhTime: UILabel!

    @IBOutlet weak var durationImg: VibaCircularImage!
    @IBOutlet weak var duration: UILabel!

    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventList.register(UINib(nibName: "ClockInOutTableViewCell", bundle: nil), forCellReuseIdentifier: "ClockInOut")

        let leftImg = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .black, size: CGSize(width: 26, height: 26))
        left.setImage(leftImg, for: .normal)
        let leftDiabledImg = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .lightGray, size: CGSize(width: 26, height: 26))
        left.setImage(leftDiabledImg, for: .disabled)

        let rightImg = UIImage.fontAwesomeIcon(name: .angleRight, style: .solid, textColor: .black, size: CGSize(width: 26, height: 26))
        right.setImage(rightImg, for: .normal)
        let rightDisabledImg = UIImage.fontAwesomeIcon(name: .angleRight, style: .solid, textColor: .lightGray, size: CGSize(width: 26, height: 26))
        right.setImage(rightDisabledImg, for: .normal)

        let calImg = UIImage.fontAwesomeIcon(name: .calendarAlt, style: .regular, textColor: .black, size: CGSize(width: 26, height: 26))
        calendar.setImage(calImg, for: .normal)

        timesheetImage.image = UIImage.fontAwesomeIcon(name: .userClock, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))
        wfoImg.image = UIImage.fontAwesomeIcon(name: .arrowUp, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))
        wfhImg.image = UIImage.fontAwesomeIcon(name: .arrowUp, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))
        durationImg.image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))

        formatAndShowDate()
    }

    @IBAction func showPreviousDay(_ sender: Any) {
        selectedDate = selectedDate.subtract(days: 1)
        formatAndShowDate()
        updatePrevNextOptions()
    }

    @IBAction func showNextDay(_ sender: Any) {
        selectedDate = selectedDate.add(days: 1)
        formatAndShowDate()
        updatePrevNextOptions()
    }

    @IBAction func selectDate(_ sender: Any) {
        // Create picker object
        let datePicker = DatePicker()
        datePicker.setup(beginWith: Date(), min: minDate, max: Date()) { [self] (selected, date) in
            if selected, let seldDate = date {
                selectedDate = seldDate
                formatAndShowDate()
                updatePrevNextOptions()
            }
        }
        // Display
        datePicker.show(in: self, on: nil)
    }

    private func formatAndShowDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM yyyy"
        self.selectedDateLabel.text = formatter.string(from: selectedDate)
    }

    private func updatePrevNextOptions() {
        let today = Date()
        if selectedDate.isSameDate(today) {
            right.isEnabled = false
            left.isEnabled = true
        } else if selectedDate.isSameDate(minDate) {
            right.isEnabled = true
            left.isEnabled = false
        } else if selectedDate.isBeforeDate(today) && today.isAfterDate(selectedDate) {
            right.isEnabled = true
            left.isEnabled = true
        }
    }
}

extension TimesheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClockInOut", for: indexPath) as? ClockInOutTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
