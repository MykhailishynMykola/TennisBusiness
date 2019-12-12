//
//  UIButton+Convenience.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 12/10/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

extension UIButton {
    func setRoundedButtonWithColor(background: UIColor, title: UIColor) {
        backgroundColor = background
        setTitleColor(title, for: .normal)
        layer.masksToBounds = false
        layer.cornerRadius = 20
    }
}
