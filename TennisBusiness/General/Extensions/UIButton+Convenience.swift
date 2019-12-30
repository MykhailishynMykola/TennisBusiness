//
//  UIButton+Convenience.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 12/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

extension UIButton {
    func configureButton(background: UIColor, title: UIColor, cornerRadius: CGFloat) {
        backgroundColor = background
        setTitleColor(title, for: .normal)
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
    }
}
