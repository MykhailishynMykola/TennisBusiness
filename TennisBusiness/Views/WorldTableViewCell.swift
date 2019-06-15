//
//  WorldTableViewCell.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/12/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class WorldTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    
    func update(with world: World) {
        self.nameLabel.text = world.name
    }
}
