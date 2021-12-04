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
    @IBOutlet weak var eventList: UITableView!
    @IBOutlet weak var leadingSpace: NSLayoutConstraint!
    @IBOutlet weak var trailingSpace: NSLayoutConstraint!
    @IBOutlet weak var wishes: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var office: VibaRoundImageButton!
    @IBOutlet weak var home: VibaRoundImageButton!
    @IBOutlet weak var confirmationView: VibaRoundCornerView!
    @IBOutlet weak var selectionView: VibaRoundCornerView!
    @IBOutlet weak var clockInAtOffice: UILabel!
    @IBOutlet weak var clockInOutBtn: VibaButton!
    @IBOutlet weak var confirmationMessage: UILabel!
    @IBOutlet weak var userImage: VibaCircularImage!

    let refreshControl = UIRefreshControl()
    var clockInOutDetails = CheckInOutListPerDayResponse()

    private var clockInOutEvent = ClockInOutEvent.clockIn

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

        name.text = DataManager.shared.fullName
        if let img = DataManager.shared.usrImage, let imageUrl = URL(string: img) {
            localImage(forKey: img.sha256, from: imageUrl) {[self] (image, _) in
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

        fetchClockInOutList()
    }

    @objc func refresh(_ sender: AnyObject) {
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
                    showWarning(message: err.localizedDescription)
                }
            }
        }
    }

    private func bringBackSelectionView() {
        UIView.animate(withDuration: 1.0) { [self] in
            leadingSpace.constant = 60
            trailingSpace.constant = 40
            selectionView.isUserInteractionEnabled = true
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
        UIView.animate(withDuration: 1.0) { [self] in
            let xpos = view.frame.width - 60
            leadingSpace.constant = -(xpos)
            trailingSpace.constant = xpos
            selectionView.isUserInteractionEnabled = false
        }
    }

    @IBAction func handleConfirmation(_ sender: Any) {
        Location.manager.fetchLocation { result in
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
                        case .failure(let err):
                            print("### Failed to post event: ", err.localizedDescription)
                            showWarning(message: "Failed to post data")
                        }
                    }

                }
            case .failure(let err):
                print("### Failed to get location: ", err.localizedDescription)
                DispatchQueue.main.async { [self] in
                    showWarning(message: "Failed to fetch location")
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
        return clockInOutDetails.count > 0 ? clockInOutDetails.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clockInOutDetails.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VibaNoRecordsCell.cellID, for: indexPath)
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClockInOutTableViewCell.cellID, for: indexPath) as? ClockInOutTableViewCell else {
            return UITableViewCell()
        }
        cell.render(data: clockInOutDetails[indexPath.row])
        return cell
    }
}
