//
//  MenuViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 24/11/21.
//

import UIKit
import FontAwesome_swift

class MenuViewController: UIViewController {
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    var menuItemsList = [
        ["image": FontAwesome.bell, "title": "Notifications"],
        ["image": FontAwesome.invision, "title": "Pre-Invitations"],
        ["image": FontAwesome.signOutAlt, "title": "Signout"]
    ]

    @IBOutlet weak var version: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoTabView))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    func gotoTabView() {
        dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }

        let item = menuItemsList[indexPath.row]
        if let img = item["image"] as? FontAwesome, let str = item["title"] as? String {
            cell.menuItem.configure(image: img, title: str)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
