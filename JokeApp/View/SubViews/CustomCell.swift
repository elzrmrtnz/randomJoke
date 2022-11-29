//
//  CustomCell.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/29/22.
//

import Foundation
import UIKit

import UIKit

class CustomCell: UITableViewCell {

    let setup = UILabel()
    let puncline = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set any attributes of your UI components here.
        setup.translatesAutoresizingMaskIntoConstraints = false
        setup.numberOfLines = 5
        setup.sizeToFit()
        
        puncline.translatesAutoresizingMaskIntoConstraints = false
        puncline.sizeToFit()
        
        // Add the UI components
        contentView.addSubview(setup)
        contentView.addSubview(puncline)
        
        NSLayoutConstraint.activate([
            setup.topAnchor.constraint(equalTo: contentView.topAnchor),
            setup.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setup.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            setup.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            puncline.leadingAnchor.constraint(equalTo: setup.leadingAnchor),
            puncline.topAnchor.constraint(equalTo: setup.bottomAnchor),
            puncline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
