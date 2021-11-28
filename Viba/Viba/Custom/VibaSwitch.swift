//
//  VibaSwitch.swift
//  Viba
//
//  Created by Satyam Sutapalli on 28/11/21.
//

import UIKit

@IBDesignable
class VibaSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        onTintColor = Colors.vibaRed.value
    }
}
