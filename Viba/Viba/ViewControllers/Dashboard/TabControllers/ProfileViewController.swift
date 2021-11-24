//
//  ProfileViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var calImage: VibaCircularImage!
    @IBOutlet weak var calDate: VibaLabel!

    @IBOutlet weak var cakeDate: VibaLabel!
    @IBOutlet weak var cakeImage: VibaCircularImage!

    @IBOutlet weak var phoneNumber: VibaLabel!
    @IBOutlet weak var phoneImage: VibaCircularImage!

    @IBOutlet weak var email: VibaLabel!
    @IBOutlet weak var emailImage: VibaCircularImage!

    @IBOutlet weak var companyImage: VibaCircularImage!
    @IBOutlet weak var company: VibaLabel!
    @IBOutlet weak var companyId: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calImage.image = UIImage.fontAwesomeIcon(name: .calendarAlt, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        cakeImage.image = UIImage.fontAwesomeIcon(name: .birthdayCake, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        phoneImage.image = UIImage.fontAwesomeIcon(name: .phone, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        emailImage.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        companyImage.image = UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
    }

    @IBAction func signOut(_ sender: Any) {
    }
}
