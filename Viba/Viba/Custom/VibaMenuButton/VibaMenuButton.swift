//
//  VibaMenuButton.swift
//  Viba
//
//  Created by Satyam Sutapalli on 24/11/21.
//

import UIKit
import FontAwesome_swift

class VibaMenuButton: UIView {
    var defaultColor = UIColor.black
    var selectedColor = Colors.vibaRed.value

    @IBOutlet var contentView: UIView!
    @IBOutlet var menuImage: VibaCircularImage!
    @IBOutlet var menuTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("VibaMenuButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        menuImage.borderWidth = 1.0
        menuImage.borderColor = .lightGray
    }

    func configure(image: FontAwesome, title: String, selected: Bool = false) {
        menuImage.image = UIImage.fontAwesomeIcon(name: image, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))
        if selected {
            menuImage.backgroundColor = selectedColor
            menuTitle.textColor = selectedColor
            menuImage.borderColor = selectedColor
        } else {
            menuImage.borderColor = defaultColor
            menuImage.backgroundColor = defaultColor
            menuTitle.textColor = defaultColor
        }
        menuTitle.text = title
    }
}
