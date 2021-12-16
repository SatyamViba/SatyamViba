//
//  NotificationsViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    @IBOutlet var notificationsImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsImage.image = UIImage.fontAwesomeIcon(name: .bell, style: .solid, textColor: .white, size: CGSize(width: 16, height: 16))
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        return cell
    }
}
