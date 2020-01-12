//
//  UIButton+Convenience.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 12/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    func configureButton(backgroundColor: UIColor, titleColor: UIColor, title: String, cornerRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        setTitle(title, for: .normal)
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
    }
}
