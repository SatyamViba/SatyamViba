//
//  TabViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 25/11/21.
//

import UIKit

enum Tab: Int {
    case dashboard = 100
    case timesheet = 200
    case clockInOut = 300
    case profile = 400
    case menu = 500
    case notifications = 600
    case preInvitations = 700

    var viewId: String {
        switch self {

        case .dashboard:
            return "DashboardView"
        case .timesheet:
            return "TimesheetView"
        case .clockInOut:
            return "ClockInView"
        case .profile:
            return "ProfileView"
        case .menu:
            return "MenuView"
        case .notifications:
            return "NotificationView"
        case .preInvitations:
            return "PreInvitationView"
        }
    }
}

class TabViewController: UIViewController {
    var selectedViewContrroller: UIViewController?
    var selectedTab = 0
    var clockIn: Bool = true {
        didSet {
            if clockIn {
                clockInOutBtn.setTitle("Clock In", for: .normal)
            } else {
                clockInOutBtn.setTitle("Clock Out", for: .normal)
            }
        }
    }
    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?
    var menuViewController: MenuViewController?

    @IBOutlet weak var container: UIView!

    @IBOutlet weak var moreBtn: VibaTabButton!
    @IBOutlet weak var profileBtn: VibaTabButton!
    @IBOutlet weak var clockInOutBtn: VibaTabButton!
    @IBOutlet weak var timesheetBtn: VibaTabButton!
    @IBOutlet weak var dashboardBtn: VibaTabButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
        dashboardBtn.tabImage = .table
        timesheetBtn.tabImage = .userClock
        clockInOutBtn.tabImage = .clock
        profileBtn.tabImage = .user
        moreBtn.tabImage = .alignJustify

        let dashboardStoryboard = UIStoryboard(name: "DashBoardWithTabs", bundle: nil)
        menuViewController = dashboardStoryboard.instantiateViewController(withIdentifier: Tab.menu.viewId) as? MenuViewController
        menuViewController?.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(goHome), name: .signOut, object: nil)

//        addChild(to: Tab.dashboard)
        perform(#selector(showInitialTab), with: nil, afterDelay: 0.25)
    }

    @objc
    private func showInitialTab() {
        addChild(to: Tab.clockInOut)
    }

    @IBAction func handleTapOnTab(_ sender: UIButton) {
        selectedTab = sender.tag
        dashboardBtn.isSelected = (dashboardBtn.tag == selectedTab)
        timesheetBtn.isSelected = (timesheetBtn.tag == selectedTab)
        clockInOutBtn.isSelected = (clockInOutBtn.tag == selectedTab)
        profileBtn.isSelected = (profileBtn.tag == selectedTab)
        moreBtn.isSelected = (moreBtn.tag == selectedTab)
        UserDefaults.standard.set(sender.tag, forKey: UserDefaultsKeys.selectedMenu.value)
        
        guard let tab = Tab(rawValue: sender.tag) else {
            return
        }

        if selectedTab == moreBtn.tag {
            showMenu()
        } else {
            addChild(to: tab)
        }
    }

    private func addChild(to tab: Tab) {
        hideContentController()
        
        let dashboardStoryboard = UIStoryboard(name: "DashBoardWithTabs", bundle: nil)
        let tabViewController = dashboardStoryboard.instantiateViewController(withIdentifier: tab.viewId)
        addChild(tabViewController)
        tabViewController.view.frame = container.bounds
        container.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: self)
        selectedViewContrroller = tabViewController
    }

    func hideContentController() {
        guard let selVc = selectedViewContrroller else {
            return
        }

        selVc.willMove(toParent: nil)
        selVc.view.removeFromSuperview()
        selVc.removeFromParent()
    }

    private func showMenu() {
        presentTransition = RightToLeftTransition()
        dismissTransition = LeftToRightTransition()

        if let menuVc = menuViewController {
            menuVc.modalPresentationStyle = .custom
            menuVc.transitioningDelegate = self

            present(menuVc, animated: true, completion: { [weak self] in
                self?.presentTransition = nil
            })
        }
    }

    @objc
    private func goHome() {
        if let navController = navigationController {
            navController.popToRootViewController(animated: true)
        }
    }
}

extension TabViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}

extension TabViewController: MenuViewDelegate {
    func showView(view: Tab) {
        addChild(to: view)
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
