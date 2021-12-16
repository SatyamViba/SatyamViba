//
//  VibaNormalButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 09/11/21.
//

import UIKit

@IBDesignable
class VibaNormalButton: UIButton {
    @IBInspectable var fontSize: CGFloat = 15 {
        didSet {
            titleLabel?.font = UIFont(name: "Poppins Medium", size: fontSize)
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
        titleLabel?.font = UIFont(name: "Poppins Medium", size: fontSize)
        setTitleColor(Colors.transparentBtnColor.value, for: .normal)
    }
}
