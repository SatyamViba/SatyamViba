//
//  Constants.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit

enum Colors {
    case gradientRed
    case gradientBlue
    case btnBackground
    case floatPlaceholderColor
    case lightLabelColor
    case transparentBtnColor
    case textFieldBorderColor
}

extension Colors {
    var value: UIColor {
        switch self {
        case .gradientRed:
            return UIColor("#FF0968")
        case .gradientBlue:
            return UIColor("#8000FF")
        case .btnBackground:
            return UIColor("#FF0968")
        case .floatPlaceholderColor:
            return UIColor("#747474")
        case .lightLabelColor:
            return UIColor("#D0D0D0")
        case .transparentBtnColor:
            return UIColor("#FF0062")
        case .textFieldBorderColor:
            return UIColor("#747474")
        }
    }
}
