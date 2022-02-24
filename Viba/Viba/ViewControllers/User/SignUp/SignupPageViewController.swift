//
//  SignupPageViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

class SignupPageViewController: UIPageViewController {
    var signupDelegate: SignupPageViewProtocol?

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            createCompanyDetailsViewController(),
            createEmployeeDetailsViewController(),
            createVerifyViewController(),
            createFaceCaptureViewController()
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    private func createCompanyDetailsViewController() -> UIViewController {
        guard let companyVC = storyboard?.instantiateViewController(withIdentifier: "CompanyDetailsView") as? CompanyVerificationViewController else {
            return UIViewController()
        }

        companyVC.delegate = self
        return companyVC
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

extension SignupPageViewController: SignupProtocol {
    func showFaceView(onCompletion handler: @escaping ((FaceCropResult) -> Void)) {
        guard let dlgt = signupDelegate else {
            handler(.notFound)
            return
        }

        dlgt.showFaceView(onCompletion: handler)
    }

    func selectDate(onCompletion handler: @escaping ((Date) -> Void)) {
        guard let dlgt = signupDelegate else {
            return
        }
        dlgt.selectDate(onCompletion: handler)
    }

    func didFinish(screen: SignupScreens) {
        guard let dlgt = signupDelegate else {
            return
        }

        switch screen {
        case .companyDetails:
            setViewControllers([orderedViewControllers[1]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            dlgt.updatePageIndicator(screen: screen)
        case .employeeDetails:
            setViewControllers([orderedViewControllers[2]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            dlgt.updatePageIndicator(screen: screen)
        case .verify:
            setViewControllers([orderedViewControllers[3]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            dlgt.updatePageIndicator(screen: screen)
        case .faceCapture(let base64Image):
            print("show dashboard")
            guard let usrId = DataManager.shared.userId, !usrId.isEmpty else {
                showWarning(title: "Warning!", message: "User ID is invalid")
                return
            }
            
            showLoadingIndicator()
            UserServices.uploadSignUpPic(userId: usrId, image: base64Image) {[self] result in
                DispatchQueue.main.async {[self] in
                    self.hideLoadingIndicator()
                    switch result {
                    case .success(let response):
                        print(response)
                        dlgt.updatePageIndicator(screen: screen)
                    case .failure(let error):
                        print("Uploading image faileld;: ", error.localizedDescription)
                        showWarning(message: "Failed to upload image")
                    }
                }
            }
        }
    }
}
