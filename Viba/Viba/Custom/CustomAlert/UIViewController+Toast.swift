//
//  Toast.swift
//  easySwiftToast
//
//  Created by wajeeh hassan on 24/11/2021.
//

import UIKit

enum ToastType {
    case success
    case info
    case error

    var bgColor: UIColor {
        switch self {
        case .success:
            return Colors.successAlert.value
        case .info:
            return Colors.infoAlert.value
        case .error:
            return Colors.errorAlert.value
        }
    }
}

extension UIViewController {
    func showAlert(message: String, type: ToastType, duration: Double = 3) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            if let appWindow = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({ $0.isKeyWindow }).first {
                if let viewWithTag = appWindow.viewWithTag(102) {
                    viewWithTag.removeFromSuperview()
                }
                
                let toastContainer = Toast(frame: CGRect()) // UIView(frame: CGRect())

                appWindow.addSubview(toastContainer)
                toastContainer.translatesAutoresizingMaskIntoConstraints = false
                
                let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: appWindow, attribute: .leading, multiplier: 1, constant: 0)
                let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: appWindow, attribute: .trailing, multiplier: 1, constant: 0)
                var topMargin = 0
                if #available(iOS 11.0, *) {
                    if UIDevice.current.hasNotch {
                        topMargin = 44
                    }
                }
                
                let c3 = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: appWindow, attribute: .top, multiplier: 1, constant: CGFloat(topMargin))
                appWindow.addConstraints([c1, c2, c3])

                toastContainer.contentView.backgroundColor = type.bgColor
                toastContainer.clipsToBounds = true
                toastContainer.tag = 102
                toastContainer.message.text = message

                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                    toastContainer.alpha = 1.0
                }, completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                        toastContainer.alpha = 0.0
                    }, completion: {_ in
                        toastContainer.removeFromSuperview()
                    })
                })
            }
        }
    }
}
