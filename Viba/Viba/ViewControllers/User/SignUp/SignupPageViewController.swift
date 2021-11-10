//
//  SignupPageViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class SignupPageViewController: UIPageViewController {
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            createEmployeeDetailsViewController(),
            createVerifyViewController(),
            createFaceCaptureViewController()
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    private func createEmployeeDetailsViewController() -> UIViewController {
        guard let empVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeeDetailsView") as? EmployeeDetailsViewController else {
            return UIViewController()
        }
        empVC.delegate = self
        return empVC
    }

    private func createVerifyViewController() -> UIViewController {
        guard let verifyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyView") as? VerifyViewController else {
            return UIViewController()
        }

        verifyVC.delegate = self
        return verifyVC
    }

    private func createFaceCaptureViewController() -> UIViewController {
        guard let fcVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FreeCaptureView") as? FaceCaptureViewController else {
            return UIViewController()
        }

        fcVC.delegate = self
        return fcVC
    }
}

extension SignupPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
}

extension SignupPageViewController: UIPageViewControllerDelegate {
    
}

extension SignupPageViewController: SignupProtocol {
    func didFinish(screen: SignupScreens) {
        switch screen {
        case .employeeDetails:
            setViewControllers([orderedViewControllers[1]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        case .verify:
            setViewControllers([orderedViewControllers[2]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        case .faceCapture:
            print("show dashboard")
        }
    }
}
