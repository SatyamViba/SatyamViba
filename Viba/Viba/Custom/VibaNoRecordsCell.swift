//
//  VibaNoRecordsCell.swift
//  Viba
//
//  Created by Satyam Sutapalli on 02/12/21.
//

import UIKit

class VibaNoRecordsCell: UITableViewCell {
    static let cellID = "EmptyCell"

    private let message = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = UIFont(name: "Poppins", size: 13)
        message.textColor = .black
        message.textAlignment = .center
        message.text = "No Records Found"
        contentView.addSubview(message)

        NSLayoutConstraint.activate([
            message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            message.topAnchor.constraint(equalTo: contentView.topAnchor),
            message.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
