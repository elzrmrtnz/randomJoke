//
//  CustomButton.swift
//  JokeApp
//
//  Created by eleazar.martinez on 12/20/22.
//

import UIKit

class CustomBtn: UIButton {
    
    enum ButtonType {
        case refresh
        case favorite
        case list
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: ButtonType) {
        switch style {
        case .refresh:
            super.init(frame: .zero)
            backgroundColor = .systemBlue
            setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
            imageView?.tintColor = UIColor.white
            setTitle(" Refresh", for: .normal)
            configDefaultProperties()
        case .favorite:
            super.init(frame: .zero)
            backgroundColor = .systemPink
            setImage(UIImage(systemName: "heart.fill"), for: .normal)
            imageView?.tintColor = UIColor.white
            setTitle(" Favorite", for: .normal)
            configDefaultProperties()
        case .list:
            super.init(frame: .zero)
            setImage(UIImage(systemName: "list.bullet"), for: .normal)
            imageView?.tintColor = UIColor.systemPink
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configDefaultProperties() {
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.white, for: .normal)
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.masksToBounds = false
        contentMode = .scaleAspectFit
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
