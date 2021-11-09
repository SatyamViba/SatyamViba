//
//  VibaLabel.swift
//  Viba
//
//  Created by Satyam Sutapalli on 09/11/21.
//

import UIKit

@IBDesignable
class VibaLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        font = UIFont(name: "Poppins", size: 15)
    }
}
