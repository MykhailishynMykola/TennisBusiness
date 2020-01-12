//
//  UIView+Convenience.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

extension UIView {
    /// Rounds the given set of corners to the specified radius with a border.
    /// - Parameters:
    ///   - corners: Corners to round.
    ///   - radius: Radius to round to.
    ///   - borderColor: The border color.
    ///   - borderWidth: The border width.
    @discardableResult func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) -> CAShapeLayer {
        let mask = round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
        return mask
    }
}

private extension UIView {
    @discardableResult func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }

    func addBorder(mask: CAShapeLayer, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        if let borderColor = borderColor {
            borderLayer.strokeColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            borderLayer.lineWidth = borderWidth
        }
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}
