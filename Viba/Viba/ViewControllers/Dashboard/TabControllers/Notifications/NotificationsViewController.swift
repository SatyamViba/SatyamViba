//
//  NotificationsViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    @IBOutlet var userImage: VibaCircularImage!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var designation: UILabel!

    @IBOutlet var notificationsImage: UIImageView!
    var profile: ProfileResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsImage.image = UIImage.fontAwesomeIcon(name: .bell, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))
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
        guard let profileToDisplay = profile else {
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
        }

        fullName.text = profileToDisplay.fullName
        designation.text = profileToDisplay.profileResponseDescription
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        return cell
    }
}
