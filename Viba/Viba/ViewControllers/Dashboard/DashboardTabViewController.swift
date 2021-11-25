//
//  DashboardTabViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit
import ESTabBarController_swift
import FontAwesome_swift

class DashboardTabViewController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    let defColor = Colors.floatPlaceholderColor.value
    let selColor = Colors.vibaRed.value
    var menuViewController: MenuViewController!

    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?


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

        if let stryBoard = storyboard, let mvc = stryBoard.instantiateViewController(withIdentifier: "MenuView") as? MenuViewController {
            menuViewController = mvc
        }

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

        selectedIndex = 2
        renderTabs()
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is MoreViewController {
            // selectedIndex = 4
            showMenu()
            return false
        }

        return true
    }

    private func showMenu() {
        presentTransition = RightToLeftTransition()
        dismissTransition = LeftToRightTransition()

        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self

        present(menuViewController, animated: true, completion: { [weak self] in
            self?.presentTransition = nil
        })
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

extension DashboardTabViewController {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}

class RightToLeftTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        container.addSubview(toView)
        toView.frame.origin = CGPoint(x: toView.frame.width, y: 0)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            toView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

class LeftToRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!

        container.addSubview(fromView)
        fromView.frame.origin = .zero

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            fromView.frame.origin = CGPoint(x: fromView.frame.width, y: 0)
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
