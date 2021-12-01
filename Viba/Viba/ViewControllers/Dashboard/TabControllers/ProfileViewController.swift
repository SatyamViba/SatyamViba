//
//  ProfileViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
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

    var profile: ProfileResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))

        calImage.image = UIImage.fontAwesomeIcon(name: .calendarAlt, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        cakeImage.image = UIImage.fontAwesomeIcon(name: .birthdayCake, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        phoneImage.image = UIImage.fontAwesomeIcon(name: .phone, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        emailImage.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
        companyImage.image = UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: .black, size: CGSize(width: 20, height: 20))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserDetails()
    }

    private func fetchUserDetails() {
        showLoadingIndicator()
        ProfileRequests.currentUser {[self] response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                switch response {
                case .success(let profileResponse):
                    self.profile = profileResponse
                    renderUI()
                case .failure(let err):
                    print(err.localizedDescription)
                    showWarning(message: err.localizedDescription)
                }
            }
        }
    }

    private func renderUI() {
        guard let profileToDisplay = profile, let joined = profileToDisplay.joined, let dob = profileToDisplay.dob else {
            return
        }

        fullName.text = profileToDisplay.fullName
        designation.text = profileToDisplay.profileResponseDescription
        calDate.text = joined.toDisplayFormat
        cakeDate.text = dob.toDisplayFormat
        phoneNumber.text = profileToDisplay.phone
        email.text = profileToDisplay.email
        company.text = profileToDisplay.account.companyName
        companyId.text = profileToDisplay.account.code
    }

    @IBAction func signOut(_ sender: Any) {
        NotificationCenter.default.post(name: .signOut, object: nil)
    }
}
