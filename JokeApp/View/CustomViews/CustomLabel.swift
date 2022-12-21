//
//  CustomLabel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 12/20/22.
//

import UIKit

class CustomLbl: UILabel {
    
    enum LabelType {
        case setup
        case puncline
    }
    
    init(style: LabelType) {
        switch style {
        case .setup:
            super.init(frame: .zero)
            text = "Loading joke..."
        case .puncline:
            super.init(frame: .zero)
            text = " "
        }
        configDefaultProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configDefaultProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        sizeToFit()
    }
}
