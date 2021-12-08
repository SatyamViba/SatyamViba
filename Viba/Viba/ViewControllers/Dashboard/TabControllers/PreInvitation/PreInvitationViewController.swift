//
//  PreInvitationViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit
import DatePicker

class PreInvitationViewController: UIViewController {
    private let minDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 2000)!

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var invitationsList: UITableView!
    @IBOutlet weak var invitationImage: UIImageView!

    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calendar: UIButton!
    @IBOutlet weak var right: UIButton!

    var invitations = InvitationListResponse()
    var selectedDate = Date() {
        didSet {
            formatAndShowDate()
            fetchInvitations()
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invitationsList.register(VibaNoRecordsCell.self, forCellReuseIdentifier: VibaNoRecordsCell.cellID)

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
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        invitationsList.addSubview(refreshControl)

        // Do any additional setup after loading the view.
        addBtn.backgroundColor = Colors.vibaRed.value
        addBtn.layer.cornerRadius = 20

        invitationImage.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))

        let plusImg = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .white, size: CGSize(width: 26, height: 26))
        addBtn.setImage(plusImg, for: .normal)

        formatAndShowDate()
        fetchInvitations()
    }

    @objc func refresh(_ sender: AnyObject) {
       fetchInvitations()
    }

    private func fetchInvitations() {
        showLoadingIndicator()
        DashboardServices.getInvitationsList(date: selectedDate) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                refreshControl.endRefreshing()
                switch result {
                case .success(let list):
                    invitations = list
                    invitationsList.reloadData()
                case .failure(let err):
                    print(err.localizedDescription)
                    showWarning(message: err.localizedDescription)
                }
            }
        }
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

extension PreInvitationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count > 0 ? invitations.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if invitations.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VibaNoRecordsCell.cellID, for: indexPath)
            return cell
        }

        let event = invitations[indexPath.row]
        if event.clockin == nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreInvitationTableViewCell.cellId, for: indexPath) as? PreInvitationTableViewCell {
                cell.configure(data: event)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PreInvitationDetailTableViewCell.cellId, for: indexPath) as? PreInvitationDetailTableViewCell {
                cell.configure(data: event)
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if invitations.count == 0 {
            return 100
        }
        
        let event = invitations[indexPath.row]
        if event.clockin == nil {
            return 90
        } else {
            return 120
        }
    }
}
