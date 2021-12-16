//
//  PreInvitationDetailTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class PreInvitationDetailTableViewCell: UITableViewCell {
    static let cellId = "PreInvitationDetailTableViewCell"

    @IBOutlet var picture: VibaCircularImage!
    @IBOutlet var name: VibaLabel!
    @IBOutlet var details: UILabel!

    @IBOutlet var clockOutTime: UILabel!
    @IBOutlet var clockInTime: UILabel!
    @IBOutlet var temperature: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = UIImage(named: "pic_holder")
        name.text = "-"
        details.text = "-"
        clockInTime.text = "-"
        clockOutTime.text = "-"
        temperature.text = "-"
    }

    func configure(data: InvitationListResponseElement) {
        guard let displayName = data.name, let prps = data.purpose, let stDate = data.start else {
            return
        }

        name.text = displayName
        details.text = prps.capitalized + " at " + stDate.toTimeDisplayFormat

        guard let cin = data.clockin, let cinTime = cin.clockedInAt else {
            return
        }
        clockInTime.text = cinTime.toTimeDisplayFormat

        if let cout = cin.clockedOutAt {
            clockOutTime.text = cout.toTimeDisplayFormat
        }

        if let temp = cin.temperature {
            temperature.text = temp.displayValue
        }
    }
}
