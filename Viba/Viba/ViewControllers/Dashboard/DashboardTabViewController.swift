//
//  DashboardTabViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit
import ESTabBarController_swift
import FontAwesome_swift

class DashboardTabViewController: UITabBarController, UITabBarControllerDelegate {
    let defColor = Colors.floatPlaceholderColor.value
    let selColor = Colors.vibaRed.value

    let tabItems = [
        [
            "image": FontAwesome.table,
            "title": "Dashbaord"
        ],
        [
            "image": FontAwesome.userClock,
            "title": "Timesheet"
        ],
        [
            "image": FontAwesome.clock,
            "title": "Clock In"
        ],
        [
            "image": FontAwesome.user,
            "title": "Profile"
        ],
        [
            "image": FontAwesome.alignJustify,
            "title": "More"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self

        // tabBar.barTintColor = .white
        tabBar.tintColor = Colors.vibaRed.value

        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Poppins", size: 13),
            NSAttributedString.Key.foregroundColor: defColor
        ]

        let selectedAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Poppins", size: 13),
            NSAttributedString.Key.foregroundColor: selColor
        ]

        UITabBarItem.appearance().setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes as [NSAttributedString.Key: Any], for: .selected)

        renderTabs()
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is MoreViewController {
            selectedIndex = 4
            return false
        }

        return true
    }

    private func renderTabs(_ curTabTapped: UITabBarItem? = nil) {
        for tabPos in 0..<tabItems.count {
            let currentTab = tabBar.items![tabPos]
            let itm = tabItems[tabPos]
            if let title = itm["title"] as? String, let img = itm["image"] as? FontAwesome {
                currentTab.title = title
                currentTab.image = UIImage.fontAwesomeIcon(name: img, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25))
            }
        }
    }
}
