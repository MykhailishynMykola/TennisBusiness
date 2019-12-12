//
//  UITextField+Convenience.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 12/9/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
