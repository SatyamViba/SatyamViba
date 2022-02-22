//
//  UIViewController+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 13/11/21.
//

import UIKit
import SCLAlertView

extension UIViewController {
    func showLoadingIndicator(text: String = "Please wait...") {
//        IGProgress.config.urlLottieJson = "loading_new"
//        IGProgress.config.message = ""
//        IGPStartLoading(config: IGProgress.config)
        LoadingStartLoading()
    }

    @objc
    func hideLoadingIndicator(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
//            IGPFinishLoading(completion: completion)
            LoadingFinishLoading(completion: completion)
        }
    }

    func showWarning(title: String = "Warning!", message: String) {
        SCLAlertView().showWarning(title, subTitle: message)
    }

    func showSuccessAlert(title: String = "Successful", message: String) {
        SCLAlertView().showSuccess(title, subTitle: message)
    }
}
