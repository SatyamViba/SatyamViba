//
//  PreInvitationTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class PreInvitationTableViewCell: UITableViewCell, VibaImageCache {
    static let cellId = "PreInvitationTableViewCell"

    @IBOutlet weak var picture: VibaCircularImage!
    @IBOutlet weak var name: VibaLabel!
    @IBOutlet weak var details: UILabel!

    override func prepareForReuse() {
        picture.image = UIImage(named: "pic_holder")
        name.text = "-"
        details.text = "-"
    }

    func configure(data: InvitationListResponseElement) {
        guard let displayName = data.name, let prps = data.purpose, let stDate = data.start else {
            return
        }
        
        name.text = displayName
        details.text = prps.capitalized + " at " + stDate.toTimeDisplayFormat
    }
}
