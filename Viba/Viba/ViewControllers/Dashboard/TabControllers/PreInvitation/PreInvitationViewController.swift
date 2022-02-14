//
//  PreInvitationViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit
import DatePicker
import ActionSheetPicker_3_0

class PreInvitationViewController: UIViewController {
    enum Status: Int, CaseIterable {
        case all = 0
        case nextInLine = 1
        case checkedIn = 2
        case checkedOut = 3

        var value: (text: String, fetchValue: String) {
            switch self {
            case .all:
                return ("All", "all")
            case .nextInLine:
                return ("Next In Line", "next")
            case .checkedIn:
                return ("Checked In", "in")
            case .checkedOut:
                return ("Checked Out", "out")
            }
        }
    }

    private let minDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 2000)!
    private let imageSize = CGSize(width: 26, height: 26)

    @IBOutlet var statusSelectionButton: UIButton!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var invitationsList: UITableView!
    @IBOutlet var invitationImage: UIImageView!

    @IBOutlet var left: UIButton!
    @IBOutlet var selectedDateLabel: UILabel!
    @IBOutlet var calendar: UIButton!
    @IBOutlet var right: UIButton!

    var currentPage = 0
    var invitations: InvitationListResponse?
    var selectedStatus = Status.all {
        didSet {
            invitations = nil
            fetchInvitations()
        }
    }
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

        let img = UIImage.fontAwesomeIcon(name: .angleDown, style: .solid, textColor: .black, size: imageSize)
        statusSelectionButton.setImage(img, for: .normal)

        let leftImg = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: .black, size: CGSize(width: 26, height: 26))
        left.setImage(leftImg, for: .normal)

        let rightImg = UIImage.fontAwesomeIcon(name: .angleRight, style: .solid, textColor: .black, size: CGSize(width: 26, height: 26))
        right.setImage(rightImg, for: .normal)

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

    @objc
    func refresh(_ sender: AnyObject) {
       fetchInvitations()
    }

    private func fetchInvitations() {
        showLoadingIndicator()
        DashboardServices.getInvitationsList(date: selectedDate, pgIndex: currentPage, status: selectedStatus.value.fetchValue) { result in
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
//        let today = Date()
//        if selectedDate.isSameDate(today) {
//            right.isEnabled = false
//            left.isEnabled = true
//        } else if selectedDate.isSameDate(minDate) {
//            right.isEnabled = true
//            left.isEnabled = false
//        } else if selectedDate.isBeforeDate(today) && today.isAfterDate(selectedDate) {
//            right.isEnabled = true
//            left.isEnabled = true
//        }
    }

    @IBAction func selectStatus(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Select a Status",
                                     rows: Status.allCases.map { $0.value.text },
                                     initialSelection: 0, doneBlock: { _, index, value in
            self.statusSelectionButton.setTitle(value as? String, for: .normal)
            self.selectedStatus = Status(rawValue: index) ?? .all
        }, cancel: { _ in
            return },
                                     origin: sender)
    }
}

extension PreInvitationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let invtns = invitations {
            return invtns.data.isEmpty ? 1 : invtns.data.count
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let invtns = invitations, !invtns.data.isEmpty else {
            return tableView.dequeueReusableCell(withIdentifier: VibaNoRecordsCell.cellID, for: indexPath)
        }

        let event = invtns.data[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: PreInvitationTableViewCell.cellId, for: indexPath) as? PreInvitationTableViewCell {
            cell.configure(data: event)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let invtns = invitations, !invtns.data.isEmpty else {
            return 100
        }

        return 110
    }
}
