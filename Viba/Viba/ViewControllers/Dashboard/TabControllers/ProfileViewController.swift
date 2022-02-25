//
//  ProfileViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit

class ProfileViewController: UIViewController, VibaImageCache {
    @IBOutlet var userImage: VibaCircularImage!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var designation: UILabel!

    @IBOutlet var profileImage: UIImageView!

    @IBOutlet var calImage: VibaCircularImage!
    @IBOutlet var calDate: VibaLabel!

    @IBOutlet var cakeDate: VibaLabel!
    @IBOutlet var cakeImage: VibaCircularImage!

    @IBOutlet var phoneNumber: VibaLabel!
    @IBOutlet var phoneImage: VibaCircularImage!

    @IBOutlet var email: VibaLabel!
    @IBOutlet var emailImage: VibaCircularImage!

    @IBOutlet var companyImage: VibaCircularImage!
    @IBOutlet var company: VibaLabel!
    @IBOutlet var companyId: UILabel!

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
        ProfileServices.currentUser {[self] response in
            DispatchQueue.main.async { [self] in
                hideLoadingIndicator()
                switch response {
                case .success(let profileResponse):
                    self.profile = profileResponse
                    renderUI()
                case .failure(let err):
                    print(err.localizedDescription)
                    showInfo(message: err.localizedDescription)
                }
            }
        }
    }

    private func renderUI() {
        guard let profileToDisplay = profile, let joined = profileToDisplay.joined, let dob = profileToDisplay.dob else {
            return
        }

        if let img = profileToDisplay.image {
            Cache.manager.get(from: img) { [self] imageData in
                if let imageReceived = imageData {
                    DispatchQueue.main.async {
                        userImage.image = UIImage(data: imageReceived)
                    }
                }
            }
//            localImage(forKey: img.sha256, from: imageUrl) {[self] (image, _) in
//                DispatchQueue.main.async { [self] in
//                    userImage.image = image
//                }
//            }
        }

        fullName.text = profileToDisplay.fullName
        designation.text = profileToDisplay.profileResponseDescription
        calDate.text = joined.toDateDisplayFormat
        cakeDate.text = dob.toDateDisplayFormat
        phoneNumber.text = profileToDisplay.phone
        email.text = profileToDisplay.email
        company.text = profileToDisplay.account.companyName
        companyId.text = profileToDisplay.account.code
    }

    @IBAction func signOut(_ sender: Any) {
        NotificationCenter.default.post(name: .signOut, object: nil)
    }
}
