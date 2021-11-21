//
//  VibaTransparentButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 09/11/21.
//

import UIKit

@IBDesignable
class VibaBorderButton: UIButton {
    @IBInspectable
    var borderColor: UIColor = Colors.transparentBtnColor.value {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable
    var textColor: UIColor = Colors.transparentBtnColor.value {
        didSet {
            setTitleColor(textColor, for: .normal)
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
        backgroundColor = .white
        layer.borderColor = Colors.transparentBtnColor.value.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        titleLabel?.font = UIFont(name: "Poppins Medium", size: 15)
        setTitleColor(Colors.transparentBtnColor.value, for: .normal)
    }
}
