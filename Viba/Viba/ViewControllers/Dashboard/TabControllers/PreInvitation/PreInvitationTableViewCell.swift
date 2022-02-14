//
//  PreInvitationTableViewCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class PreInvitationTableViewCell: UITableViewCell, VibaImageCache {
    static let cellId = "PreInvitationTableViewCell"

    @IBOutlet var picture: VibaCircularImage!
    @IBOutlet var name: UILabel!
    @IBOutlet var details: UILabel!

    @IBOutlet var msgBtn: VibaRoundImageButton!
    @IBOutlet var callBtn: VibaRoundImageButton!

    @IBOutlet var statusView: UIView!
    @IBOutlet var statusText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let callImg = UIImage.fontAwesomeIcon(name: .phone, style: .solid, textColor: .black, size: CGSize(width: 18, height: 18))
        callBtn.setImage(callImg, for: .normal)

        let rectShape = CAShapeLayer()
        rectShape.bounds = self.statusView.frame
        rectShape.position = self.statusView.center
        rectShape.path = UIBezierPath(roundedRect: self.statusView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath

        statusView.layer.mask = rectShape

//        statusView.layer.borderWidth = 1.0
//        statusView.layer.borderColor = UIColor(hex: "#156D00").cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
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

    @IBAction func callMember(_ sender: Any) {
    }

    @IBAction func messageMember(_ sender: Any) {
    }
}
