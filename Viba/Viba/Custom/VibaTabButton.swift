//
//  VibaTabButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 26/11/21.
//

import UIKit
import FontAwesome_swift

@IBDesignable
class VibaTabButton: UIButton {
    var tabImage = FontAwesome.clock {
        didSet {
            commonInit()
        }
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)

        return CGRect(x: 0, y: contentRect.height - rect.height - 8,
                      width: contentRect.width, height: rect.height)
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)

        return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
                             y: (contentRect.height - titleRect.height)/2.0 - rect.height/2.0,
                             width: rect.width, height: rect.height)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize

        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0

            if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }

            return CGSize(width: size.width, height: image.size.height + labelHeight + 5)
        }

        return size
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerTitleLabel()
    }

    private func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Poppins", size: 10)
        setTitleColor(Colors.vibaRed.value, for: .selected)
        setTitleColor(Colors.floatPlaceholderColor.value, for: .normal)
    }

    private func commonInit() {
        setImage(UIImage.fontAwesomeIcon(name: tabImage, style: .solid, textColor: Colors.vibaRed.value, size: CGSize(width: 26, height: 26)), for: .selected)
        setImage(UIImage.fontAwesomeIcon(name: tabImage, style: .solid, textColor: Colors.floatPlaceholderColor.value, size: CGSize(width: 26, height: 26)), for: .normal)
    }
}
