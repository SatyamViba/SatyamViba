//
//  VibaCircularImage.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit

@IBDesignable
class VibaCircularImage: UIImageView {
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = .lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        makeRound()
    }

    override internal var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            makeRound()
        }
    }

    private func makeRound() {
        self.clipsToBounds = true
        self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
    }

    override func layoutSubviews() {
        makeRound()
    }
}
