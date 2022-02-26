//
//  estentions.swift
//  easySwiftToast
//
//  Created by wajeeh hassan on 24/11/2021.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        guard let appWindow = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({ $0.isKeyWindow }).first else {
                    return false
                }
        
        let bottom = appWindow.safeAreaInsets.bottom
        return bottom > 0
    }
}
