//
//  UIViewController+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 13/11/21.
//

import UIKit

extension UIViewController {
    func showLoadingIndicator(text: String = "Please wait...") {
        IGProgress.config.urlLottieJson = "circles"
        IGProgress.config.message = text
        self.IGPStartLoading(config: IGProgress.config)
    }

    func hideLoadingIndicator() {
        self.IGPFinishLoading()
    }
}
