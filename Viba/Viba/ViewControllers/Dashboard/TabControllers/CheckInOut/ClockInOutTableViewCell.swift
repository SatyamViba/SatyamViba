//
//  ClockInOutTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 22/11/21.
//

import UIKit

class ClockInOutTableViewCell: UITableViewCell {

    @IBOutlet weak var clockInOutSymbol: VibaCircularImage!
    @IBOutlet weak var clockInOutTitle: UILabel!

    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var eventTime: UILabel!

    @IBOutlet weak var tempImg: UIImageView!
    @IBOutlet weak var temperature: UILabel!

    @IBOutlet weak var workLocation: UIImageView!
    @IBOutlet weak var place: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        clockInOutSymbol.image = UIImage.fontAwesomeIcon(name: .arrowUp, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        clockImg.image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))
        tempImg.image = UIImage.fontAwesomeIcon(name: .thermometerHalf, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))
        workLocation.image = UIImage.fontAwesomeIcon(name: .houseUser, style: .solid, textColor: .black, size: CGSize(width: 12, height: 12))
    }

    func renderData() {

    }
}
