//
//  PlayerTableViewCell.swift
//  TennisBusiness
//
//  Created by Mac on 8/18/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
     // MARK: - Properties

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var returnLabel: UILabel!
    @IBOutlet private weak var serveLabel: UILabel!
    @IBOutlet private weak var skillLabel: UILabel!
    
    
    
    // MARK: - Public
    
    func update(with player: Player) {
        let ability = player.ability
        nameLabel.text = player.name
        returnLabel.text = String(ability.returnOfServe.intValue)
        serveLabel.text = String(ability.serve.intValue)
        skillLabel.text = String(ability.skill.intValue)
    }
}
