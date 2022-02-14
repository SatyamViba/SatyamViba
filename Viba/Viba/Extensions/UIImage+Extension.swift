//
//  UIImage+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 28/11/21.
//

import UIKit

extension UIImage {
    func convertImageToBase64() -> String? {
        let imageData = self.pngData()
        return imageData?.base64EncodedString(options: .lineLength64Characters)
    }

    func toBase64() -> String? {
        return pngData()?.base64EncodedString()
    }
}
