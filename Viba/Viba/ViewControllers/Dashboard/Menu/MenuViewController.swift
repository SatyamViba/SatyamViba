//
//  MenuViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 24/11/21.
//

import UIKit
import FontAwesome_swift

protocol MenuViewDelegate: AnyObject {
    func showView(view: Tab)
}

class MenuViewController: UIViewController {
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var delegate: MenuViewDelegate?

    var menuItems = [
        ["image": FontAwesome.bell, "title": "Notifications"],
        ["image": FontAwesome.invision, "title": "Pre-Invitations"],
        ["image": FontAwesome.signOutAlt, "title": "Signout"]
    ]

    @IBOutlet var version: UILabel!
    @IBOutlet var menuItemsList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoTabView))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)

        if let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let bld = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            version.text = "Powered By VIBA - v\(ver) (\(bld)"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMenu()
    }
    
    @objc
    func gotoTabView() {
        dismiss(animated: true, completion: nil)
    }

    func reloadMenu() {
        menuItemsList.reloadData()
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }

        var selected = false
        let currentMenu = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMenu.value) as Int
        if currentMenu == indexPath.row {
            selected = true
        }

        let item = menuItems[indexPath.row]
        if let img = item["image"] as? FontAwesome, let str = item["title"] as? String {
            cell.menuItem.configure(image: img, title: str, selected: selected)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == menuItems.count - 1 {
            UserDefaults.standard.set(-1, forKey: UserDefaultsKeys.selectedMenu.value)
            NotificationCenter.default.post(name: .signOut, object: nil)
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(indexPath.row, forKey: UserDefaultsKeys.selectedMenu.value)
        reloadMenu()

        if let dlgt = delegate {
            switch indexPath.row {
            case 0:
                dlgt.showView(view: .notifications)
            case 1:
                dlgt.showView(view: .preInvitations)
            default:
                print("### Handle it!!")
            }
        }
    }
}
