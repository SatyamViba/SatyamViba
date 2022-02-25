//
//  DashboardViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit
import FontAwesome_swift
import CoreLocation

enum ClockInOutEvent {
    case clockIn
    case clockOut

    var url: String {
        switch self {
        case .clockIn:
            return NetworkPath.clockIn.rawValue
        case .clockOut:
            return NetworkPath.clockOut.rawValue
        }
    }
}

class ClockInOutViewController: UIViewController, VibaImageCache {
    @IBOutlet var eventList: UITableView!
    @IBOutlet var leadingSpace: NSLayoutConstraint!
    @IBOutlet var trailingSpace: NSLayoutConstraint!
    @IBOutlet var wishes: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var dateAndTime: VibaLabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var office: VibaRoundImageButton!
    @IBOutlet var home: VibaRoundImageButton!
    @IBOutlet var confirmationView: UIView!
    @IBOutlet var confirmationBgView: VibaRoundCornerView!
    @IBOutlet var selectionView: VibaRoundCornerView!
    @IBOutlet var clockInAtOffice: UILabel!
    @IBOutlet var clockInOutBtn: VibaButton!
    @IBOutlet var confirmationMessage: VibaLabel!
    @IBOutlet var userImage: VibaCircularImage!

    let refreshControl = UIRefreshControl()
    var clockInOutDetails: CheckInOutListPerDayResponse? {
        didSet {
            if let cinDetails = clockInOutDetails, !cinDetails.activities.isEmpty {
                if let lastObj = cinDetails.activities.first, lastObj.clockedOutAt != nil {
                    clockInOutEvent = .clockIn
                } else {
                    clockInOutEvent = .clockOut
                }
            } else {
                clockInOutEvent = .clockIn
            }
        }
    }

    let dispatchGroup = DispatchGroup()

    private var clockInOutEvent = ClockInOutEvent.clockIn {
        didSet {
            if clockInOutEvent == .clockIn {
                clockInOutBtn.setTitle("Clock In", for: .normal)
                confirmationMessage.text = "Are you ready to Clockin?"
            } else {
                clockInOutBtn.setTitle("Clock Out", for: .normal)
                confirmationMessage.text = "Are you ready to Clock out?"
            }
        }
    }

    private var workFromHome = true {
        didSet {
            if workFromHome {
                handleHomeSelection(home)
            } else {
                handleOfficeSelection(office)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let degrees: CGFloat = -4.0
        let radians: CGFloat = degrees * (.pi / 180)
        confirmationBgView.transform = CGAffineTransform(rotationAngle: radians)

        name.text = DataManager.shared.fullName
        if let img = DataManager.shared.usrImage, let imageUrl = URL(string: img) {
            localImage(forKey: img.sha256, from: imageUrl) {[self] image, _ in
                DispatchQueue.main.async { [self] in
                    userImage.image = image
                }
            }
        }

        eventList.register(UINib(nibName: "ClockInOutTableViewCell", bundle: nil), forCellReuseIdentifier: ClockInOutTableViewCell.cellID)
        eventList.register(VibaNoRecordsCell.self, forCellReuseIdentifier: VibaNoRecordsCell.cellID)

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        eventList.addSubview(refreshControl)

        wishes.text = Utility.getWish()
        dateAndTime.text = Date().formatToDateTime()

        let ofcImg = UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25))
        office.setImage(ofcImg, for: .normal)
        office.backgroundColor = Colors.btnSelected.value

        let homeImg = UIImage.fontAwesomeIcon(name: .houseUser, style: .solid, textColor: Colors.floatPlaceholderColor.value, size: CGSize(width: 25, height: 25))
        home.setImage(homeImg, for: .normal)
        home.backgroundColor = Colors.btnUnselected.value

        clockInOutBtn.isHidden = true
        clockInAtOffice.isHidden = false

        message.text = "WFO - Work From Office"

        let btnImg = UIImage.fontAwesomeIcon(name: .clock, style: .regular, textColor: .white, size: CGSize(width: 25, height: 25))
        clockInOutBtn.setImage(btnImg, for: .normal)

        let spacing: CGFloat = 10 // the amount of spacing to appear between image and title
        clockInOutBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        clockInOutBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)

        updateUI()
    }

    private func updateUI() {
        let callsGroup = DispatchGroup()
        showLoadingIndicator()

        callsGroup.enter()
        Location.manager.fetchLocation { [self] result in
            switch result {
            case .success(let location):
                //                showLoadingIndicator()
                let usrLocation = GeoLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                DashboardServices.checkOutsideOrg(data: ClockInOut(geoLocation: usrLocation)) { response in
                    DispatchQueue.main.async { [self] in
                        hideLoadingIndicator()
                        callsGroup.leave()
                        switch response {
                        case .success(let dataReceived):
                            workFromHome = dataReceived.outsideOrg
                        case .failure(let err):
                            print("### ", err.localizedDescription)
                            showInfo(message: "Failed to check user location")
                        }
                    }
                }
            case .failure(let err):
                callsGroup.leave()
                print("### Failed to get location: ", err.localizedDescription)
                DispatchQueue.main.async { [self] in
                    showInfo(message: "Failed to fetch location")
                }
            }
        }

        callsGroup.enter()
        //        showLoadingIndicator()
        DashboardServices.getCheckInOutDetailsByDate(date: Date()) { [self] response in
            callsGroup.leave()
            DispatchQueue.main.async { [self] in
                //                hideLoadingIndicator()
                //                refreshControl.endRefreshing()
                switch response {
                case .success(let list):
                    self.clockInOutDetails = list
                    eventList.reloadData()
                case .failure(let err):
                    print(err.localizedDescription)
                    showInfo(message: err.localizedDescription)
                }
            }
        }

        callsGroup.notify(queue: DispatchQueue.main) {
            self.hideLoadingIndicator()
        }
    }

    private func checkIfUserIsInOffice() {
        Location.manager.fetchLocation { [self] result in
            switch result {
            case .success(let location):
                showLoadingIndicator()
                let usrLocation = GeoLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                DashboardServices.checkOutsideOrg(data: ClockInOut(geoLocation: usrLocation)) { response in
                    DispatchQueue.main.async { [self] in
                        hideLoadingIndicator()
                        switch response {
                        case .success(let dataReceived):
                            workFromHome = dataReceived.outsideOrg
                        case .failure(let err):
                            print("### ", err.localizedDescription)
                            showInfo(message: "Failed to check user location")
                        }
                    }
                }
            case .failure(let err):
                print("### Failed to get location: ", err.localizedDescription)
                DispatchQueue.main.async { [self] in
                    showInfo(message: "Failed to fetch location")
                }
            }
        }
    }

    @objc
    func refresh(_ sender: AnyObject) {
       fetchClockInOutList()
    }

    private func fetchClockInOutList() {
        showLoadingIndicator()
        DashboardServices.getCheckInOutDetailsByDate(date: Date()) { [self] response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                refreshControl.endRefreshing()
                switch response {
                case .success(let list):
                    self.clockInOutDetails = list
                    eventList.reloadData()
                case .failure(let err):
                    print(err.localizedDescription)
                    showInfo(message: err.localizedDescription)
                }
            }
        }
    }

    private func bringBackSelectionView() {
        UIView.animate(withDuration: 0.5) { [self] in
            leadingSpace.constant = 35
            trailingSpace.constant = 20
            selectionView.isUserInteractionEnabled = true
            view.layoutIfNeeded()
        }
    }

    @IBAction func handleOfficeSelection(_ sender: UIButton) {
        let ofcImg = UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25))
        office.setImage(ofcImg, for: .normal)
        office.backgroundColor = Colors.btnSelected.value

        let homeImg = UIImage.fontAwesomeIcon(name: .houseUser, style: .solid, textColor: Colors.floatPlaceholderColor.value, size: CGSize(width: 25, height: 25))
        home.setImage(homeImg, for: .normal)
        home.backgroundColor = Colors.btnUnselected.value

        message.text = "WFO - Work From Office"
        clockInOutBtn.isHidden = true
        clockInAtOffice.isHidden = false
    }

    @IBAction func handleHomeSelection(_ sender: UIButton) {
        let ofcImg = UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: Colors.floatPlaceholderColor.value, size: CGSize(width: 25, height: 25))
        office.setImage(ofcImg, for: .normal)
        office.backgroundColor = Colors.btnUnselected.value

        let homeImg = UIImage.fontAwesomeIcon(name: .houseUser, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25))
        home.setImage(homeImg, for: .normal)
        home.backgroundColor = Colors.btnSelected.value

        message.text = "WFH - Work From Home"
        clockInOutBtn.isHidden = false
        clockInAtOffice.isHidden = true
    }

    @IBAction func handleClockInOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) { [self] in
            let xpos = view.frame.width - 35
            leadingSpace.constant = -(xpos)
            trailingSpace.constant = xpos
            selectionView.isUserInteractionEnabled = false
            view.layoutIfNeeded()
        }
    }

    @IBAction func handleConfirmation(_ sender: Any) {
        Location.manager.fetchLocation { [self] result in
            switch result {
            case .success(let location):
                showLoadingIndicator()
                let usrLocation = GeoLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                DashboardServices.sendClockInClockOut(eventType: clockInOutEvent, data: ClockInOut(geoLocation: usrLocation)) { response in
                    DispatchQueue.main.async { [self] in
                        hideLoadingIndicator()
                        switch response {
                        case .success(let dataReceived):
                            print(dataReceived)
                            bringBackSelectionView()
                            fetchClockInOutList()
                        case .failure(let err):
                            print("### Failed to post event: ", err.localizedDescription)
                            showInfo(message: "Failed to post data")
                        }
                    }
                }
            case .failure(let err):
                print("### Failed to get location: ", err.localizedDescription)
                DispatchQueue.main.async { [self] in
                    showInfo(message: "Failed to fetch location")
                }
            }
        }
    }

    @IBAction func handleCancellation(_ sender: Any) {
        bringBackSelectionView()
    }
}

extension ClockInOutViewController: UITableViewDataSource, UITableViewDelegate {
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
