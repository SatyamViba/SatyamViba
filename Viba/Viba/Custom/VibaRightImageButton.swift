//
//  VibaRightImageButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 16/01/22.
//

import UIKit

class VibaRightImageButton: UIButton {
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = super.titleRect(forContentRect: contentRect).maxX - imageFrame.width
        return imageFrame
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleFrame = super.titleRect(forContentRect: contentRect)
        if self.currentImage != nil {
            titleFrame.origin.x = super.imageRect(forContentRect: contentRect).minX
        }
        return titleFrame
    }
}
