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
        IGProgress.config.urlLottieJson = "circles"
        IGProgress.config.message = text
        IGPStartLoading(config: IGProgress.config)
    }

    @objc func hideLoadingIndicator() {
        IGPFinishLoading()
    }

    func showWarning(title: String = "Warning!", message: String) {
        SCLAlertView().showWarning(title, subTitle: message)
    }

    func showSuccessAlert(title: String = "Successful", message: String) {
        SCLAlertView().showSuccess(title, subTitle: message)
    }
}
