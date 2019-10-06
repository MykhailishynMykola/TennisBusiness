//
//  MatchTableViewCell.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 10/6/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var firstPlayerLabel: UILabel!
    @IBOutlet private weak var secondPlayerLabel: UILabel!
    @IBOutlet private weak var result: UILabel!
    
    
    
    // MARK: - Public
    
    func update(with match: Match) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: match.eventDate)
        
        firstPlayerLabel.text = match.firstPlayer.fullName
        secondPlayerLabel.text = match.secondPlayer.fullName
        result.text = ""
    }
}
