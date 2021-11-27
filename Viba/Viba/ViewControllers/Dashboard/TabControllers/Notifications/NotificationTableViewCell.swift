//
//  NotificationTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var title: VibaLabel!
    @IBOutlet weak var cellImage: VibaCircularImage!
    @IBOutlet weak var status: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
