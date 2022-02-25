//
//  UIViewController+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 13/11/21.
//

import UIKit

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

    func showInfo(message: String) {
        showAlert(message: message, type: .info)
    }

    func showSuccessAlert(message: String) {
        showAlert(message: message, type: .success)
    }

    func showError(message: String) {
        showAlert(message: message, type: .error)
    }
}
