//
//  DashboardViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit
import FontAwesome_swift

class ClockInOutViewController: UIViewController {

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

    private var isClockIn = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }

    @IBAction func handleOfficeSelection(_ sender: Any) {
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

    @IBAction func handleHomeSelection(_ sender: Any) {
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

    @IBAction func handleClockInOut(_ sender: Any) {
        UIView.animate(withDuration: 1.0) { [self] in
            let xpos = view.frame.width - 60
            leadingSpace.constant = -(xpos)
            trailingSpace.constant = xpos
            selectionView.isUserInteractionEnabled = false
        }
    }

    @IBAction func handleConfirmation(_ sender: Any) {
        bringBackSelectionView()
    }

    @IBAction func handleCancellation(_ sender: Any) {
        bringBackSelectionView()
    }

    private func bringBackSelectionView() {
        UIView.animate(withDuration: 1.0) { [self] in
            leadingSpace.constant = 60
            trailingSpace.constant = 40
            selectionView.isUserInteractionEnabled = true
        }
    }
}

extension ClockInOutViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
