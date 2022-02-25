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
    @IBOutlet var eventList: UITableView!
    @IBOutlet var timesheetImage: UIImageView!

    @IBOutlet var cinStatus: UILabel!
    @IBOutlet var coutStatus: UILabel!
    @IBOutlet var durationStatus: UILabel!

    @IBOutlet var left: UIButton!
    @IBOutlet var selectedDateLabel: UILabel!
    @IBOutlet var calendar: UIButton!
    @IBOutlet var right: UIButton!

    @IBOutlet var inImage: VibaCircularImage!
    @IBOutlet var inTime: UILabel!

    @IBOutlet var outImage: VibaCircularImage!
    @IBOutlet var outTime: UILabel!

    @IBOutlet var durationImg: VibaCircularImage!
    @IBOutlet var duration: UILabel!

    var clockInOutDetails: CheckInOutListPerDayResponse?
    var selectedDate = Date() {
        didSet {
            formatAndShowDate()
            fetchClockInOutList()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventList.register(UINib(nibName: "ClockInOutTableViewCell", bundle: nil), forCellReuseIdentifier: ClockInOutTableViewCell.cellID)
        eventList.register(VibaNoRecordsCell.self, forCellReuseIdentifier: VibaNoRecordsCell.cellID)
        
        let leftImg = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .black, size: CGSize(width: 26, height: 26))
        left.setImage(leftImg, for: .normal)
        let leftDiabledImg = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .lightGray, size: CGSize(width: 26, height: 26))
        left.setImage(leftDiabledImg, for: .disabled)

        let rightImg = UIImage.fontAwesomeIcon(name: .angleRight, style: .solid, textColor: .black, size: CGSize(width: 26, height: 26))
        right.setImage(rightImg, for: .normal)
        let rightDisabledImg = UIImage.fontAwesomeIcon(name: .angleRight, style: .solid, textColor: .lightGray, size: CGSize(width: 26, height: 26))
        right.setImage(rightDisabledImg, for: .disabled)

        let calImg = UIImage.fontAwesomeIcon(name: .calendarAlt, style: .regular, textColor: .black, size: CGSize(width: 26, height: 26))
        calendar.setImage(calImg, for: .normal)

        timesheetImage.image = UIImage.fontAwesomeIcon(name: .userClock, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))
        inImage.image = UIImage.fontAwesomeIcon(name: .arrowUp, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))
        outImage.image = UIImage.fontAwesomeIcon(name: .arrowDown, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))
        durationImg.image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: .black, size: CGSize(width: 16, height: 16))

        formatAndShowDate()
        fetchClockInOutList()
    }

    private func fetchClockInOutList() {
        showLoadingIndicator()
        DashboardServices.getCheckInOutDetailsByDate(date: selectedDate) { [self] response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                switch response {
                case .success(let list):
                    self.clockInOutDetails = list
                    eventList.reloadData()
                    uploadTodaysStatus()
                case .failure(let err):
                    print(err.localizedDescription)
                    showInfo(message: err.localizedDescription)
                }
            }
        }
    }

    private func uploadTodaysStatus() {
        guard let status = clockInOutDetails?.checkin else {
            cinStatus.text = "--"
            coutStatus.text = "--"
            durationStatus.text = "0.0"
            return
        }

        cinStatus.text = status.mode?.clockin?.rawValue ?? "--"
        coutStatus.text = status.mode?.clockout?.rawValue ?? "--"
        inTime.text = status.clockedInAt?.toTimeDisplayFormat ?? "--"
        outTime.text = status.clockedOutAt?.toTimeDisplayFormat ?? "--"
        durationStatus.text = status.hours ?? "0.0"
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
        datePicker.setup(beginWith: Date(), min: minDate, max: Date()) { [self] selected, date in
            if selected, let seldDate = date {
                selectedDate = seldDate
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
        if let cinDetails = clockInOutDetails, !cinDetails.activities.isEmpty {
            return cinDetails.activities.count
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cinDetails = clockInOutDetails, !cinDetails.activities.isEmpty else {
            return tableView.dequeueReusableCell(withIdentifier: VibaNoRecordsCell.cellID, for: indexPath)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClockInOutTableViewCell.cellID, for: indexPath) as? ClockInOutTableViewCell else {
            return UITableViewCell()
        }

        cell.render(data: cinDetails.activities[indexPath.row])
        return cell
    }
}
