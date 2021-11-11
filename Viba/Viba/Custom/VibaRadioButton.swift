//
//  VibaRadioButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 11/11/21.
//

import UIKit
import DLRadioButton

@IBDesignable
class VibaRadioButton: DLRadioButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        iconSize = 20
        iconColor = Colors.vibaRed.value
        indicatorSize = 10
        indicatorColor = Colors.vibaRed.value
        marginWidth = 10
        titleLabel?.font = UIFont(name: "Poppins", size: 15)
    }
}
