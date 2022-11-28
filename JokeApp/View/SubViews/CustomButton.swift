//
//  CustomButton.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/26/22.
//

import UIKit

struct CustomButtonVM {
    
    let text: String
    let image: UIImage?
    let backgroundColor: UIColor?
}

class CustomButton: UIButton {
    private let btnLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private let btnIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(btnLabel)
        addSubview(btnIcon)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: CustomButtonVM) {
        btnLabel.text = viewModel.text
        backgroundColor = viewModel.backgroundColor
        btnIcon.image = viewModel.image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btnLabel.sizeToFit()
        let iconSize: CGFloat = 18
        let iconX: CGFloat = (frame.size.width - btnLabel.frame.size.width - iconSize - 5) / 2
        btnIcon.frame = CGRect(x: iconX,
                                y: (frame.size.height-iconSize)/2,
                                width: iconSize,
                                height: iconSize)
       btnLabel.frame = CGRect(x: iconX + iconSize + 5,
                                y: 0,
                                width: btnLabel.frame.size.width,
                                height: frame.size.height)
    }
}
