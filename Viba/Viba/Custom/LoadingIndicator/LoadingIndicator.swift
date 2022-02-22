//
//  LoadingIndicator.swift
//  Viba
//
//  Created by Satyam Sutapalli on 22/02/22.
//

import UIKit

public class LoadingIndicator {
    public  static var controller: UIViewController?
    static var alertLottie: LoadingIndicatorViewController?
    public  static var control = false
    private static let nameStoryBoard: String = "LoadingIndicator"
    private static let controllerId: String = "loading"

    public init(controller: UIViewController) {
        LoadingIndicator.controller = controller
    }

    public static func startLoading() {
        if !control {
            let storyboard = UIStoryboard(name: LoadingIndicator.nameStoryBoard, bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: LoadingIndicator.controllerId) as? LoadingIndicatorViewController else {
                return
            }
            
            LoadingIndicator.alertLottie = vc
            LoadingIndicator.control = true
            LoadingIndicator.alertLottie!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            LoadingIndicator.alertLottie!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            LoadingIndicator.controller?.present(LoadingIndicator.alertLottie!, animated: true, completion: nil)
        }
    }

    public static  func finishLoading(completion: (() -> Void)? = nil) {
        if LoadingIndicator.alertLottie != nil {
            LoadingIndicator.alertLottie?.dismiss(animated: true, completion: completion)
            LoadingIndicator.control = false
        }
    }
}

public extension UIViewController {
    func LoadingStartLoading() {
        LoadingIndicator.controller = self
        LoadingIndicator.startLoading()
    }

    func LoadingFinishLoading(completion: (() -> Void)? = nil) {
        LoadingIndicator.finishLoading(completion: completion)
    }
}
