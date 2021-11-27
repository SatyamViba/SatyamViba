//
//  PreInvitationViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class PreInvitationViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var invitationsList: UITableView!
    @IBOutlet weak var invitationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBtn.backgroundColor = Colors.vibaRed.value
        addBtn.layer.cornerRadius = 20

        invitationImage.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))

        let plusImg = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .white, size: CGSize(width: 26, height: 26))
        addBtn.setImage(plusImg, for: .normal)
    }
}

extension PreInvitationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationCell", for: indexPath)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationDetailCell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 90
        } else {
            return 120
        }
    }
}
