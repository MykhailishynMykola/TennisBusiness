//
//  ChooseWorldTableViewCell.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ChooseWorldTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    
    private let dateFormatter = DateFormatter()
    private var bottomBorder: CALayer?
    private var labels: [UILabel] {
        return [nameLabel, speedLabel, createdAtLabel]
    }
    
    
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.primary.withAlphaComponent(0.19)
        self.selectedBackgroundView = selectedBackgroundView
        dateFormatter.dateFormat = "MM.dd.yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        bottomBorder = layer.addBorder(edge: .bottom, color: .primary, thickness: 3)
        labels.forEach {
            $0.font = UIFont(name: "OpenSans-Bold", size: 17)
            $0.textColor = .primary
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard DeviceInfo.isTablet else { return }
        bottomBorder?.removeFromSuperlayer()
        bottomBorder = layer.addBorder(edge: .bottom, color: .primary, thickness: 3)
    }
    
    
    
    // MARK: - Public
    
    func update(with world: World) {
        nameLabel.text = world.name
        speedLabel.text = "x\(Int(world.speed))"
        createdAtLabel.text = dateFormatter.string(from: world.createdAt)
    }
}
