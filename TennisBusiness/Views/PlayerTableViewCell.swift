//
//  PlayerTableViewCell.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 8/18/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var returnLabel: UILabel!
    @IBOutlet private weak var serveLabel: UILabel!
    @IBOutlet private weak var skillLabel: UILabel!
    @IBOutlet private weak var countryBonusLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    
    
    
    // MARK: - Public
    
    func update(with player: Player, date: Date) {
        let ability = player.ability
        nameLabel.text = player.fullName
        returnLabel.text = String(ability.returnOfServe.doubleValue)
        serveLabel.text = String(ability.serve.doubleValue)
        skillLabel.text = String(ability.skill.doubleValue)
        countryBonusLabel.text =
            String(ability.countryBonus.doubleValue)
        ageLabel.text = "\(player.birthday.ageInt(to: date))"
    }
}
