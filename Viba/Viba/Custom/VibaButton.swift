//
//  VibaButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit

@IBDesignable
class VibaButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = Colors.btnBackground.value
        layer.cornerRadius = 5.0
        titleLabel?.font = UIFont(name: "Poppins Medium", size: 15)
        titleLabel?.textColor = .white
    }
}
