//
//  ClockInOutTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 22/11/21.
//

import UIKit

class ClockInOutTableViewCell: UITableViewCell {
    static let cellID = "ClockInOutCell"

    @IBOutlet var clockInSymbol: VibaCircularImage!
    @IBOutlet var clockOutSymbol: VibaCircularImage!

    @IBOutlet var clockInTimeImg: UIImageView!
    @IBOutlet var clockInTime: UILabel!
    @IBOutlet var clockOutTimeImg: UIImageView!
    @IBOutlet var clockOutTime: UILabel!

    @IBOutlet var tempImg: UIImageView!
    @IBOutlet var temperature: UILabel!

    @IBOutlet var clockInWorkLocationImg: UIImageView!
    @IBOutlet var clockInWorkLocationName: UILabel!
    @IBOutlet var clockOutWorkLocationImg: UIImageView!
    @IBOutlet var clockOutWorkLocationName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        clockInSymbol.image = UIImage.fontAwesomeIcon(name: .arrowUp, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        clockOutSymbol.image = UIImage.fontAwesomeIcon(name: .arrowDown, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))

        clockInTimeImg.image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))
        clockOutTimeImg.image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))

        tempImg.image = UIImage.fontAwesomeIcon(name: .thermometerHalf, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))

        clockInWorkLocationImg.image = UIImage.fontAwesomeIcon(name: .houseUser, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))
        clockOutWorkLocationImg.image = UIImage.fontAwesomeIcon(name: .houseUser, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clockInTime.text = "-"
        clockOutTime.text = "-"
        temperature.text = "-"
        clockInWorkLocationName.text = "-"
        clockOutWorkLocationName.text = "-"
    }

    func render(data: Activity) {
        print(data)
        guard let clockedIn = data.clockedInAt, let mode = data.mode, let cinMode = mode.clockin else {
            return
        }

        clockInTime.text = clockedIn.toTimeDisplayFormat
        clockInWorkLocationName.text = cinMode.rawValue

        clockOutTime.text = data.clockedOutAt?.toTimeDisplayFormat ?? "--"
        clockOutWorkLocationName.text = mode.clockout?.rawValue ?? "--"

        temperature.text = data.temperature?.displayValue ?? "--"
    }
}
