//
//  CALayer+Convenience.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

extension CALayer {
    @discardableResult func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) -> CALayer? {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            return nil
        }
        border.backgroundColor = color.cgColor;
        addSublayer(border)
        return border
    }
}
