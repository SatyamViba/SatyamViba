//
//  NotificationTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet var title: VibaLabel!
    @IBOutlet var cellImage: VibaCircularImage!
    @IBOutlet var status: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
