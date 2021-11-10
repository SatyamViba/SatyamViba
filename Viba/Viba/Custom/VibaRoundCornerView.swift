//
//  VibaRoundCornerView.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

@IBDesignable
class VibaRoundCornerView: UIView {
    @IBInspectable
    var cornerRadius: CGFloat = 3.0 {
        didSet {
            layer.cornerRadius = cornerRadius
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
        layer.cornerRadius = cornerRadius
    }
}
